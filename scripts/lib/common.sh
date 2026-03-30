#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
readonly _S="$(basename "$0")"
readonly _L="/var/log/wyoming-enhancements/${_S%.sh}.log"
mkdir -p "$(dirname "${_L}")" 2>/dev/null || true
log_info()  { printf '[%s] INFO  %s: %s\n' "$(date +%H:%M:%S)" "${_S}" "$*" | tee -a "${_L}"; }
log_warn()  { printf '[%s] WARN  %s: %s\n' "$(date +%H:%M:%S)" "${_S}" "$*" | tee -a "${_L}" >&2; }
log_error() { printf '[%s] ERROR %s: %s\n' "$(date +%H:%M:%S)" "${_S}" "$*" | tee -a "${_L}" >&2; }
trap 'ec=$?; [ $ec -ne 0 ] && log_error "exit $ec"; exit $ec' EXIT
retry() {
  local max=${1:-3} w=${2:-5} n=1; shift 2
  until "$@"; do
    [ $n -ge $max ] && { log_error "failed after $max tries: $*"; return 1; }
    log_warn "attempt $n/$max failed"; sleep $w; w=$((w*2)); n=$((n+1))
  done
}
require_cmd() { for c in "$@"; do command -v "$c" &>/dev/null || { log_error "missing: $c"; exit 1; }; done; }
