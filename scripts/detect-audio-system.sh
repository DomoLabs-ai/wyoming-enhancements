#!/bin/bash
source "$(dirname "$0")/lib/common.sh"
detect() {
  systemctl --user is-active pipewire-pulse.service &>/dev/null && { echo pipewire-pulse; return; }
  systemctl --user is-active pipewire.service &>/dev/null && { echo pipewire; return; }
  systemctl --user is-active pulseaudio.service &>/dev/null && { echo pulseaudio; return; }
  echo alsa
}
sys="$(detect)"
log_info "detected audio system: ${sys}"
case "${sys}" in
  pipewire-pulse) export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native" ;;
  pipewire) apt-get install -y pipewire-pulse 2>/dev/null && systemctl --user enable --now pipewire-pulse.service 2>/dev/null || true ;;
  alsa) apt-get install -y pulseaudio 2>/dev/null || true ;;
esac
