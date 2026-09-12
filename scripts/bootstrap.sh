#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
  Linux) bootstrap="${SCRIPT_DIR}/bootstrap-linux.sh" ;;
  Darwin) bootstrap="${SCRIPT_DIR}/bootstrap-darwin.sh" ;;
  *)
    printf 'error: unsupported operating system: %s\n' "$(uname -s)" >&2
    exit 1
    ;;
esac

exec "${bootstrap}" "$@"
