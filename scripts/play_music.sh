#!/bin/bash
source "$(dirname "$0")/lib/common.sh"
log_info "play_music: starting playback routing"
require_cmd pactl paplay

MUSIC_FILE="${1:-}"
DOMO_AUDIO_SINK="${WYOMING_MUSIC_SINK:-DomoAudio}"
FALLBACK_SINK="${WYOMING_FALLBACK_SINK:-@DEFAULT_SINK@}"

if [ -z "${MUSIC_FILE}" ]; then
  log_error "usage: play_music.sh <file_or_url>"
  exit 1
fi

find_domo_audio_sink() {
  pactl list short sinks 2>/dev/null | grep -i "${DOMO_AUDIO_SINK}" | awk '{print $2}' | head -1
}

SINK="$(find_domo_audio_sink)"
if [ -z "${SINK}" ]; then
  log_warn "domoaudio sink not found, checking domoaudio-client status"
  if systemctl is-active --quiet domoaudio-client 2>/dev/null; then
    sleep 2
    SINK="$(find_domo_audio_sink)"
  fi
fi

if [ -z "${SINK}" ]; then
  log_warn "domoaudio sink unavailable, using fallback: ${FALLBACK_SINK}"
  SINK="${FALLBACK_SINK}"
fi

log_info "routing music to sink: ${SINK}"
if [[ "${MUSIC_FILE}" == http* ]]; then
  require_cmd ffmpeg
  ffmpeg -i "${MUSIC_FILE}" -f s16le -acodec pcm_s16le -ar 48000 -ac 2 pipe:1 2>/dev/null | \
    paplay --device="${SINK}" --raw --rate=48000 --channels=2 --format=s16le 2>/dev/null || \
    log_error "streaming playback failed for: ${MUSIC_FILE}"
else
  if [ ! -f "${MUSIC_FILE}" ]; then
    log_error "file not found: ${MUSIC_FILE}"
    exit 1
  fi
  paplay --device="${SINK}" "${MUSIC_FILE}" 2>/dev/null || \
    (command -v aplay &>/dev/null && aplay -q "${MUSIC_FILE}" 2>/dev/null) || \
    log_error "local playback failed for: ${MUSIC_FILE}"
fi
log_info "play_music: playback complete"
