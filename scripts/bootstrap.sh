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

usage() {
  printf 'usage: %s [--host HOST]\n' "$0"
}

requested_host="${HOST:-}"
while (( $# > 0 )); do
  case "$1" in
    --host)
      (( $# >= 2 )) || die "--host requires a value"
      requested_host="$2"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      die "unknown argument: $1"
      ;;
  esac
done

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

if ! command -v git >/dev/null 2>&1; then
  log "Git is unavailable; restarting bootstrap with a temporary Git package"
  reexec_args=( )
  if [[ -n "${requested_host}" ]]; then
    reexec_args=(--host "${requested_host}")
  fi
  exec nix --extra-experimental-features "${FLAKE_FEATURES}" \
    shell nixpkgs#git -c "${SCRIPT_DIR}/bootstrap.sh" "${reexec_args[@]}"
fi

command -v nixos-rebuild >/dev/null 2>&1 || die \
  "nixos-rebuild is unavailable; this script must run on NixOS"

cd "${REPO_DIR}"
nix_cmd=(nix --extra-experimental-features "${FLAKE_FEATURES}")

configured_host="${requested_host:-$(hostname -s)}"
[[ "${configured_host}" =~ ^[a-zA-Z0-9._-]+$ ]] || die \
  "invalid host name: ${configured_host}"

if ! configured_hostname="$(
  "${nix_cmd[@]}" eval --raw \
    ".#nixosConfigurations.${configured_host}.config.networking.hostName"
)"; then
  die "no NixOS configuration named ${configured_host}"
fi
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
  "host ${configured_host} selects ${configured_system}, but this machine is ${detected_system}"
[[ "${configured_hostname}" == "$(hostname -s)" ]] || die \
  "host ${configured_host} configures hostname ${configured_hostname}, but this machine is $(hostname -s)"
[[ "${configured_user}" == "$(id -un)" ]] || die \
  "host ${configured_host} selects user ${configured_user}, but you are $(id -un)"

password_hash_file="$(
  "${nix_cmd[@]}" eval --raw \
    ".#nixosConfigurations.${configured_host}.config.users.users.${configured_user}.hashedPasswordFile" \
    --apply 'value: if value == null then "" else toString value'
)"
if [[ -n "${password_hash_file}" ]]; then
  if ! sudo test -s "${password_hash_file}"; then
    die "missing or empty password hash: ${password_hash_file}"
  fi
fi

log "Validating configuration ${configured_host}"
"${nix_cmd[@]}" flake check --all-systems
"${nix_cmd[@]}" eval --raw \
  ".#nixosConfigurations.${configured_host}.config.system.build.toplevel.drvPath" \
  >/dev/null

log "Building configuration ${configured_host}"
nixos-rebuild build \
  --option experimental-features "${FLAKE_FEATURES}" \
  --flake ".#${configured_host}"

log "Applying configuration ${configured_host}"
sudo "$(command -v nixos-rebuild)" switch \
  --option experimental-features "${FLAKE_FEATURES}" \
  --flake ".#${configured_host}"

log "Bootstrap complete"
printf '%s\n' \
  "Open a new terminal so all PATH and shell changes take effect." \
  "Future changes: cd ${REPO_DIR} && make apply" \
  "Before committing, run: make check"
