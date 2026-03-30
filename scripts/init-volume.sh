#!/bin/bash
source "$(dirname "$0")/lib/common.sh"
log_info "initializing ALSA mixer levels"
require_cmd amixer
PLAYBACK_VOL="${PLAYBACK_VOLUME:-75%}"
CAPTURE_VOL="${CAPTURE_VOLUME:-60%}"
for CTL in Master Speaker Headphone PCM; do
  amixer -q sset "${CTL}" "${PLAYBACK_VOL}" 2>/dev/null && log_info "set ${CTL} to ${PLAYBACK_VOL}" || true
done
for CTL in Capture Mic "Mic Boost"; do
  amixer -q sset "${CTL}" "${CAPTURE_VOL}" 2>/dev/null && log_info "set ${CTL} to ${CAPTURE_VOL}" || true
done
amixer -q sset "Auto Gain Control" off 2>/dev/null || true
alsactl store 2>/dev/null || log_warn "could not persist ALSA settings"
log_info "mixer levels initialized: playback=${PLAYBACK_VOL} capture=${CAPTURE_VOL}"
