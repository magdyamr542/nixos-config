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

if [[ "$(uname -s)" != "Darwin" ]]; then
  die "this bootstrap script supports macOS only"
fi

case "$(uname -m)" in
  arm64) detected_system="aarch64-darwin" ;;
  x86_64) detected_system="x86_64-darwin" ;;
  *) die "unsupported architecture: $(uname -m)" ;;
esac

log "Detected ${detected_system}"

if ! command -v nix >/dev/null 2>&1; then
  command -v curl >/dev/null 2>&1 || die "curl is required to install Nix"
  installer_file="$(mktemp -t nix-install.XXXXXX)"
  trap 'rm -f "${installer_file:-}"' EXIT

  log "Nix is not installed"
  printf '%s\n' \
    "The official multi-user installer will explain its changes and request sudo." \
    "Review its prompt before accepting. This script will not uninstall Homebrew."
  curl --proto '=https' --tlsv1.2 --fail --silent --show-error --location \
    https://nixos.org/nix/install --output "${installer_file}"
  sh "${installer_file}" --daemon

  if [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    # shellcheck disable=SC1091
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
fi

command -v nix >/dev/null 2>&1 || die "Nix was installed but is not on PATH; open a new shell and rerun this script"

cd "${REPO_DIR}"
nix_cmd=(nix --extra-experimental-features "${FLAKE_FEATURES}")

configured_host="$(
  "${nix_cmd[@]}" eval --raw .#darwinConfigurations \
    --apply 'configs: builtins.head (builtins.attrNames configs)'
)"
configured_system="$(
  "${nix_cmd[@]}" eval --raw \
    ".#darwinConfigurations.${configured_host}.config.nixpkgs.hostPlatform.system"
)"
configured_user="$(
  "${nix_cmd[@]}" eval --raw \
    ".#darwinConfigurations.${configured_host}.config.system.primaryUser"
)"

[[ "${configured_system}" == "${detected_system}" ]] || die \
  "hosts/default.nix selects ${configured_system}, but this Mac is ${detected_system}"
[[ "${configured_user}" == "$(id -un)" ]] || die \
  "hosts/default.nix selects user ${configured_user}, but you are $(id -un)"

log "Validating the flake"
"${nix_cmd[@]}" flake check --all-systems
"${nix_cmd[@]}" eval --raw \
  ".#darwinConfigurations.${configured_host}.config.system.build.toplevel.drvPath" >/dev/null

log "Applying nix-darwin configuration ${configured_host}"
printf '%s\n' "The initial system activation requires sudo."
sudo "$(command -v nix)" --extra-experimental-features "${FLAKE_FEATURES}" \
  run .#darwin-rebuild -- switch --flake ".#${configured_host}"

log "Bootstrap complete"
printf '%s\n' \
  "Open a new terminal so all PATH and shell changes take effect." \
  "Future changes: cd ${REPO_DIR} && make apply" \
  "Before committing, run: make check"
