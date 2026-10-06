{
  pkgs ?
    import
      (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/ece1ef61e70aeb885f17a1609e09739907453bab.tar.gz";
      })
      {
        config.allowUnfree = true;
      },
}:

let
  claude =
    if builtins.hasAttr "claude-code" pkgs then
      pkgs."claude-code"
    else if builtins.hasAttr "claude-code-bin" pkgs then
      pkgs."claude-code-bin"
    else
      throw ''
        Neither "claude-code" nor "claude-code-bin" exists in the selected nixpkgs commit.
      '';

  codex = pkgs.codex;
in
pkgs.mkShell {
  packages = [
    claude
    codex
    pkgs.vagrant
    pkgs.age
    pkgs.sops
  ];

  shellHook = ''
    r2_secret_file=/run/secrets/immich-r2.env

    if [ -r "$r2_secret_file" ]; then
      set -a
      . "$r2_secret_file"
      set +a

      export RCLONE_CONFIG=/dev/null
      export RCLONE_CONFIG_R2_TYPE=s3
      export RCLONE_CONFIG_R2_PROVIDER=Cloudflare
      export RCLONE_CONFIG_R2_ACCESS_KEY_ID="$R2_ACCESS_KEY_ID"
      export RCLONE_CONFIG_R2_SECRET_ACCESS_KEY="$R2_SECRET_ACCESS_KEY"
      export RCLONE_CONFIG_R2_REGION=auto
      export RCLONE_CONFIG_R2_ENDPOINT="$R2_ENDPOINT"
      export RCLONE_CONFIG_R2_NO_CHECK_BUCKET=true
    else
      echo "R2 credentials not loaded: $r2_secret_file is missing or unreadable." >&2
    fi

    unset r2_secret_file

    if ! vagrant plugin list 2>/dev/null | grep -q '^vagrant-disksize'; then
      echo "Installing vagrant-disksize plugin..."
      vagrant plugin install vagrant-disksize
    fi
  '';
}
