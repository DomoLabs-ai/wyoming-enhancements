#!/bin/bash
source "$(dirname "$0")/lib/common.sh"
PERIOD="${ALSA_PERIOD_SIZE:-1024}"
BUFFER="${ALSA_BUFFER_SIZE:-8192}"
log_info "configuring ALSA buffer: period=${PERIOD} buffer=${BUFFER}"
CONF="/etc/asound.conf"
if [ -f "${CONF}" ]; then
  log_warn "${CONF} already exists, backing up"
  cp "${CONF}" "${CONF}.bak.$(date +%s)"
fi
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cp "${SCRIPT_DIR}/config/alsa-usb-buffer.conf" "${CONF}"
sed -i "s/period_size 1024/period_size ${PERIOD}/" "${CONF}"
sed -i "s/buffer_size 8192/buffer_size ${BUFFER}/" "${CONF}"
log_info "ALSA buffer configured at ${CONF}"
