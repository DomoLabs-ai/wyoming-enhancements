#!/bin/bash
source "$(dirname "$0")/lib/common.sh"
log_info "detecting ALSA output devices"
require_cmd aplay
PREFERRED="${WYOMING_AUDIO_OUTPUT:-}"
if [ -n "${PREFERRED}" ]; then
  log_info "using configured output: ${PREFERRED}"
  echo "${PREFERRED}"
  exit 0
fi
CARDS="$(aplay -l 2>/dev/null | grep "^card" || true)"
if [ -z "${CARDS}" ]; then
  log_error "no ALSA playback devices found"
  exit 1
fi
USB="$(echo "${CARDS}" | grep -i usb | head -1 || true)"
if [ -n "${USB}" ]; then
  CARD="$(echo "${USB}" | sed -n "s/card \([0-9]*\):.*/\1/p")"
  DEV="$(echo "${USB}" | sed -n "s/.*device \([0-9]*\):.*/\1/p")"
  log_info "selected USB audio: hw:${CARD},${DEV}"
  echo "hw:${CARD},${DEV}"
  exit 0
fi
FIRST="$(echo "${CARDS}" | head -1)"
CARD="$(echo "${FIRST}" | sed -n "s/card \([0-9]*\):.*/\1/p")"
DEV="$(echo "${FIRST}" | sed -n "s/.*device \([0-9]*\):.*/\1/p")"
log_info "selected first available: hw:${CARD},${DEV}"
echo "hw:${CARD},${DEV}"
