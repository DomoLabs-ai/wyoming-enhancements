#!/bin/bash
source "$(dirname "$0")/lib/common.sh"
log_info "setting up audio stream separation"
require_cmd pactl
CONF_DIR="/etc/pulse/default.pa.d"
mkdir -p "${CONF_DIR}" 2>/dev/null || true
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cp "${SCRIPT_DIR}/config/pulseaudio-streams.pa" "${CONF_DIR}/90-wyoming-streams.pa"
log_info "stream separation config installed"
pulseaudio -k 2>/dev/null || true
sleep 1
pulseaudio --start 2>/dev/null || systemctl --user restart pulseaudio 2>/dev/null || true
log_info "PulseAudio restarted with stream separation"
