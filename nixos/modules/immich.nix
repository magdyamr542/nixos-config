{
  config,
  host,
  pkgs,
  ...
}:
let
  projectDir = "/etc/immich";
  r2MountPoint = "/srv/immich/r2";
  r2CacheDir = "/srv/immich/rclone-cache";
  r2CredentialsFile = config.sops.secrets."immich-r2.env".path;
  databasePassword = config.sops.secrets."immich-db-password".path;
  r2MountCommand = pkgs.writeShellScript "immich-r2-mount" ''
    set -euo pipefail

    : "''${R2_ACCESS_KEY_ID:?R2_ACCESS_KEY_ID is required}"
    : "''${R2_SECRET_ACCESS_KEY:?R2_SECRET_ACCESS_KEY is required}"
    : "''${R2_ENDPOINT:?R2_ENDPOINT is required}"
    : "''${R2_BUCKET:?R2_BUCKET is required}"

    export RCLONE_CONFIG=/dev/null
    export RCLONE_CONFIG_R2_TYPE=s3
    export RCLONE_CONFIG_R2_PROVIDER=Cloudflare
    export RCLONE_CONFIG_R2_ACCESS_KEY_ID="$R2_ACCESS_KEY_ID"
    export RCLONE_CONFIG_R2_SECRET_ACCESS_KEY="$R2_SECRET_ACCESS_KEY"
    export RCLONE_CONFIG_R2_REGION=auto
    export RCLONE_CONFIG_R2_ENDPOINT="$R2_ENDPOINT"
    export RCLONE_CONFIG_R2_NO_CHECK_BUCKET=true

    exec ${pkgs.rclone}/bin/rclone mount "r2:$R2_BUCKET" ${r2MountPoint} \
      --allow-other \
      --cache-dir ${r2CacheDir} \
      --vfs-cache-mode writes \
      --vfs-cache-max-size 200G \
      --vfs-cache-min-free-space 100G \
      --vfs-cache-max-age 1h \
      --vfs-cache-poll-interval 1m \
      --vfs-write-back 15s \
      --transfers 4 \
      --dir-cache-time 5m \
      --attr-timeout 1s
  '';
in
{
  environment.systemPackages = [ pkgs.rclone ];

  sops.secrets."immich-r2.env" = {
    sopsFile = ../../secrets/immich-r2.env;
    format = "dotenv";
    owner = host.username;
    group = host.username;
    mode = "0400";
  };

  # Docker accesses the R2 FUSE mount through bind mounts below. The parent
  # directory permissions still constrain direct host access.
  programs.fuse.userAllowOther = true;

  # Secure remote access is handled by Tailscale Serve in a later activation
  # step. Immich itself stays bound to localhost.
  services.tailscale = {
    enable = true;
    disableTaildrop = true;
    # Allows authenticated WireGuard handshakes for direct peer-to-peer
    # transfers; it does not publish the Immich HTTP port.
    openFirewall = true;
  };

  # The secret is encrypted in secrets/secrets.yaml and only materialized at
  # runtime. Docker Compose passes it to the two containers as a file-backed
  # Compose secret, never as an environment variable.
  sops.secrets."immich-db-password" = {
    owner = "root";
    group = "root";
    mode = "0400";
  };

  systemd.tmpfiles.rules = [
    "d /srv/immich 0750 root ${host.username} -"
    "d ${r2MountPoint} 0750 root root -"
    "d ${r2CacheDir} 0750 root root -"
    "d /srv/immich/local 0750 ${host.username} ${host.username} -"
    "d /srv/immich/local/thumbs 0750 ${host.username} ${host.username} -"
    "d /srv/immich/local/encoded-video 0750 ${host.username} ${host.username} -"
    "d /srv/immich/local/profile 0750 ${host.username} ${host.username} -"
    "d /srv/immich/local/backups 0750 ${host.username} ${host.username} -"
    "d /srv/immich/local/model-cache 0750 root root -"
    "d /srv/immich/postgres 0700 999 999 -"
  ];

  systemd.services.immich-r2-mount = {
    description = "Immich Cloudflare R2 filesystem mount";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      EnvironmentFile = r2CredentialsFile;
      ExecStartPre = [ "${pkgs.coreutils}/bin/test -r ${r2CredentialsFile}" ];
      ExecStart = r2MountCommand;
      Restart = "on-failure";
      RestartSec = "10s";
      TimeoutStopSec = "2min";
      KillSignal = "SIGINT";
    };
  };

  environment.etc."immich/immich.env".text = ''
    UPLOAD_LOCATION=/srv/immich/local
    DB_DATA_LOCATION=/srv/immich/postgres
    TZ=Europe/Berlin
    IMMICH_VERSION=v3.2.4
    DB_USERNAME=postgres
    DB_DATABASE_NAME=immich
  '';

  # Based on Immich v3.2.4's official release Compose file. The differences
  # are deliberately limited to local-only ingress, R2-backed source paths,
  # Docker secrets, and systemd-controlled lifecycle.
  environment.etc."immich/docker-compose.yml".text = ''
    name: immich

    services:
      immich-server:
        container_name: immich_server
        image: ghcr.io/immich-app/immich-server:''${IMMICH_VERSION}
        volumes:
          - ''${UPLOAD_LOCATION}:/data
          - ${r2MountPoint}/upload:/data/upload
          - ${r2MountPoint}/library:/data/library
          - /etc/localtime:/etc/localtime:ro
        env_file:
          - ${projectDir}/immich.env
        environment:
          DB_PASSWORD_FILE: /run/secrets/immich-db-password
        secrets:
          - immich-db-password
        ports:
          - '127.0.0.1:2283:2283'
        depends_on:
          - redis
          - database
        restart: 'no'
        healthcheck:
          disable: false

      immich-machine-learning:
        container_name: immich_machine_learning
        image: ghcr.io/immich-app/immich-machine-learning:''${IMMICH_VERSION}
        volumes:
          - /srv/immich/local/model-cache:/cache
        env_file:
          - ${projectDir}/immich.env
        restart: 'no'
        healthcheck:
          disable: false

      redis:
        container_name: immich_redis
        image: docker.io/valkey/valkey:9@sha256:70739f85ad2ee01a726a965584a0f94895f01b0c60b3cc8b0aeef11eaa6888cf
        healthcheck:
          test: redis-cli ping | grep -q PONG || exit 1
        restart: 'no'

      database:
        container_name: immich_postgres
        image: ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23
        environment:
          POSTGRES_PASSWORD_FILE: /run/secrets/immich-db-password
          POSTGRES_USER: ''${DB_USERNAME}
          POSTGRES_DB: ''${DB_DATABASE_NAME}
          POSTGRES_INITDB_ARGS: '--data-checksums'
        secrets:
          - immich-db-password
        volumes:
          - ''${DB_DATA_LOCATION}:/var/lib/postgresql/data
        shm_size: 128mb
        restart: 'no'
        healthcheck:
          disable: false

    secrets:
      immich-db-password:
        file: ${databasePassword}
  '';

  # Systemd, rather than Docker restart policies, owns the lifecycle. This
  # preserves mount ordering at boot and stops Immich if the R2 mount vanishes.
  systemd.services.immich = {
    description = "Immich photo management service";
    requires = [
      "docker.service"
      "immich-r2-mount.service"
    ];
    bindsTo = [ "immich-r2-mount.service" ];
    # Propagate a deliberate or automatic mount-service restart to Immich, so
    # it returns only after the R2 filesystem is available again.
    partOf = [ "immich-r2-mount.service" ];
    after = [
      "docker.service"
      "immich-r2-mount.service"
    ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = projectDir;
      ExecStartPre = [ "${pkgs.util-linux}/bin/mountpoint -q ${r2MountPoint}" ];
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose --project-directory ${projectDir} --env-file ${projectDir}/immich.env up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose --project-directory ${projectDir} --env-file ${projectDir}/immich.env down";
      TimeoutStartSec = "15min";
      TimeoutStopSec = "5min";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

  # Reapply the private tailnet-only HTTPS proxy after boot. The one-time
  # `tailscale up` login remains interactive and is not stored in Nix.
  systemd.services.immich-tailscale-serve = {
    description = "Private Tailscale HTTPS access for Immich";
    # Start after the backend, but keep the private proxy configured while the
    # backend is briefly unavailable during an R2 mount recovery.
    wants = [
      "tailscaled.service"
      "immich.service"
    ];
    # Keep the tailnet endpoint configured through a short Immich restart. The
    # proxy returns a backend error while Immich is unavailable, then resumes
    # automatically once the localhost service is back.
    after = [
      "tailscaled.service"
      "immich.service"
    ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --https=443 http://127.0.0.1:2283";
      ExecStop = "${pkgs.tailscale}/bin/tailscale serve --https=443 off";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
