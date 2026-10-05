# Immich architecture

The `amr` NixOS workstation runs a private Immich instance for iPhone photo
backup and browsing. This document describes the deployed design; it does not
contain credentials or the tailnet's private hostname.

## Design goals

- Keep original photo and video assets in a private Cloudflare R2 bucket.
- Keep latency-sensitive state, including PostgreSQL, on the host filesystem.
- Expose Immich only to authenticated Tailscale devices.
- Make service ordering explicit so Immich cannot write to an unmounted R2
  path.
- Keep credentials encrypted in this repository and materialize them only at
  activation time.

```mermaid
flowchart TB
  phone[iPhone / Immich app]
  tailnet[Tailscale tailnet\nprivate HTTPS]

  subgraph host[amr NixOS host]
    serve[Tailscale Serve\nHTTPS → 127.0.0.1:2283]

    subgraph compose[Immich Docker Compose]
      server[Immich server]
      ml[Machine learning]
      db[(PostgreSQL\nlocal disk)]
      cache[Valkey]
    end

    subgraph local[Local host storage]
      generated[thumbnails, encoded videos,\nprofiles, database dumps]
      vfs[Rclone VFS write cache\n200 GB max, 100 GB free floor]
    end

    rclone[rclone FUSE mount\n/srv/immich/r2]
  end

  r2[(Cloudflare R2\nimmich-photos\nprivate EU jurisdiction bucket)]

  phone --> tailnet --> serve --> server
  server <--> db
  server <--> cache
  server <--> ml
  server --> generated
  server --> rclone
  rclone <--> vfs
  rclone <--> r2
```

## Storage layout

| Data | Location | Notes |
| --- | --- | --- |
| Original uploaded assets | `immich-photos` R2 bucket | Private R2 Standard bucket. With Immich's default Storage Template configuration, mobile uploads are in `upload/<user-id>/`. |
| R2 filesystem interface | `/srv/immich/r2` | Root-owned rclone FUSE mount. Immich binds its `upload/` and `library/` paths from here. |
| Temporary original-file cache | `/srv/immich/rclone-cache` | rclone VFS write cache. It is bounded to 200 GB, keeps 100 GB host free, and expires successful files after one hour. It is not an independent backup. |
| Database | `/srv/immich/postgres` | PostgreSQL data remains on local disk; it is never placed behind rclone/R2. |
| Generated media and application data | `/srv/immich/local` | Thumbnails, encoded videos, profiles, Immich database dumps, and ML model cache are local. Originals are not deliberately retained here after the rclone cache expires. |

Cloudflare R2 is configured as a private EU-jurisdiction bucket. The account
token is limited to object read/write for this bucket. The endpoint, access key,
secret, and bucket name are in the encrypted `secrets/immich-r2.env` file and
are materialized by sops-nix at `/run/secrets/immich-r2.env`; there is no
persistent `rclone.conf`.

## Services and availability

`immich-r2-mount.service` starts rclone after the network is online. The
`immich.service` systemd unit requires and binds to that mount, checks that the
mount point is active before starting Docker Compose, and is restarted when the
mount service restarts. This prevents Immich from accidentally writing into an
ordinary local directory if the FUSE mount disappears.

Docker Compose runs four containers: Immich server, Immich machine learning,
PostgreSQL, and Valkey. Docker restart policies are deliberately disabled;
systemd owns their lifecycle so mount ordering is preserved.

The Immich server listens only on `127.0.0.1:2283`. `tailscale serve` provides
HTTPS only within the authenticated tailnet and proxies to that listener.
Tailscale Funnel is not enabled, and PostgreSQL and Valkey have no host ports.
The Serve unit remains configured during a brief Immich restart, so R2 mount
recovery restores the backend without removing the tailnet endpoint.

## Secrets and operations

The PostgreSQL password is a sops-managed secret exposed to Compose as a file
secret; it is not put in the Compose environment. The R2 dotenv file has
mode `0400` at runtime. Never add decrypted secret files, rclone configuration,
or Cloudflare credentials to Git.

Apply configuration only after reviewing it:

```sh
make HOST=amr build
make HOST=amr apply
```

## Backup status

R2 holds the primary original assets, but a complete recovery plan still needs
an independently tested PostgreSQL/configuration backup and restore procedure.
That work is intentionally tracked separately before this deployment is called
fully disaster-recoverable. Do not use Immich's **Free Up Space** feature or
delete Apple Photos/iCloud originals as part of this deployment.
