#!/bin/bash
source "$(dirname "$0")/lib/common.sh"
get_debian_codename() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "${VERSION_CODENAME:-unknown}"
  else
    echo "unknown"
  fi
}
CODENAME="$(get_debian_codename)"
log_info "detected Debian codename: ${CODENAME}"
case "${CODENAME}" in
  bookworm|trixie)
    export DOMO_AUDIO_CLIENT_PKG="snapclient"
    export LIBFLAC_PKG="libflac-dev"
    ;;
  bullseye|buster)
    export DOMO_AUDIO_CLIENT_PKG="snapclient"
    export LIBFLAC_PKG="libflac8"
    ;;
  *)
    log_warn "unknown Debian version: ${CODENAME}, using defaults"
    export DOMO_AUDIO_CLIENT_PKG="snapclient"
    export LIBFLAC_PKG="libflac-dev"
    ;;
esac
log_info "package mapping: snapclient=${DOMO_AUDIO_CLIENT_PKG} libflac=${LIBFLAC_PKG}"
