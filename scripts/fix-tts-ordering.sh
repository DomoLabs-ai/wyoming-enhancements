#!/bin/bash
source "$(dirname "$0")/lib/common.sh"
log_info "fixing TTS service ordering"
OVERRIDE_DIR="/etc/systemd/system/wyoming-satellite.service.d"
mkdir -p "${OVERRIDE_DIR}"
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cp "${SCRIPT_DIR}/systemd/wyoming-satellite.service.override" "${OVERRIDE_DIR}/override.conf"
systemctl daemon-reload
log_info "TTS service ordering fixed - wyoming-satellite will wait for PulseAudio"
