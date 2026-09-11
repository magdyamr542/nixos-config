#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
readonly FLAKE_FEATURES="nix-command flakes"

log() {
  printf '\n==> %s\n' "$*"
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

if [[ "$(uname -s)" != "Linux" ]]; then
  die "this bootstrap script supports Linux only"
fi

case "$(uname -m)" in
  x86_64) detected_system="x86_64-linux" ;;
  aarch64) detected_system="aarch64-linux" ;;
  *) die "unsupported architecture: $(uname -m)" ;;
esac

command -v nix >/dev/null 2>&1 || die \
  "Nix is not installed; install NixOS before running this repository bootstrap"
command -v nixos-rebuild >/dev/null 2>&1 || die \
  "nixos-rebuild is unavailable; this script must run on NixOS"

cd "${REPO_DIR}"
nix_cmd=(nix --extra-experimental-features "${FLAKE_FEATURES}")

configured_host="$(
  "${nix_cmd[@]}" eval --raw .#nixosConfigurations \
    --apply 'configs: builtins.head (builtins.attrNames configs)'
)"
configured_system="$(
  "${nix_cmd[@]}" eval --raw \
    ".#nixosConfigurations.${configured_host}.config.nixpkgs.hostPlatform.system"
)"
configured_user="$(
  "${nix_cmd[@]}" eval --raw \
    ".#nixosConfigurations.${configured_host}.config.home-manager.users" \
    --apply 'users: builtins.head (builtins.attrNames users)'
)"

[[ "${configured_system}" == "${detected_system}" ]] || die \
  "hosts/linux.nix selects ${configured_system}, but this machine is ${detected_system}"
[[ "${configured_user}" == "$(id -un)" ]] || die \
  "hosts/linux.nix selects user ${configured_user}, but you are $(id -un)"

readonly password_hash_file="/etc/nixos/secrets/${configured_user}-password-hash"
if ! sudo test -s "${password_hash_file}"; then
  die "missing or empty password hash: ${password_hash_file}"
fi

required_ssh_keys=(
  "${HOME}/.ssh/github"
  "${HOME}/.ssh/gitlab_tu_dortmund"
)
for ssh_key_file in "${required_ssh_keys[@]}"; do
  if [[ ! -s "${ssh_key_file}" ]]; then
    die "missing or empty SSH private key: ${ssh_key_file}"
  fi
done

log "Validating configuration ${configured_host}"
"${nix_cmd[@]}" flake check --all-systems
"${nix_cmd[@]}" eval --raw \
  ".#nixosConfigurations.${configured_host}.config.system.build.toplevel.drvPath" \
  >/dev/null

log "Building configuration ${configured_host}"
nixos-rebuild build --flake ".#${configured_host}"

log "Applying configuration ${configured_host}"
sudo "$(command -v nixos-rebuild)" switch --flake ".#${configured_host}"

log "Bootstrap complete"
printf '%s\n' \
  "Open a new terminal so all PATH and shell changes take effect." \
  "Future changes: cd ${REPO_DIR} && make apply" \
  "Before committing, run: make check"
