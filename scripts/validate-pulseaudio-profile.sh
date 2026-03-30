#!/bin/bash
source "$(dirname "$0")/lib/common.sh"
log_info "validating PulseAudio profiles"
require_cmd pactl
MODULES="$(pactl list modules short 2>/dev/null || true)"
if ! echo "${MODULES}" | grep -q "module-bluetooth-discover"; then
  log_warn "module-bluetooth-discover not loaded, loading..."
  pactl load-module module-bluetooth-discover 2>/dev/null || log_warn "failed to load bluetooth module"
fi
CARDS="$(pactl list cards short 2>/dev/null || true)"
if [ -z "${CARDS}" ]; then
  log_error "no PulseAudio cards found"
  exit 1
fi
log_info "available cards:"
echo "${CARDS}" | while read -r line; do log_info "  ${line}"; done
CARD="${1:-}"
PROFILE="${2:-}"
if [ -n "${CARD}" ] && [ -n "${PROFILE}" ]; then
  PROFILES="$(pactl list cards 2>/dev/null | grep -A50 "Name: ${CARD}" | grep "output:" || true)"
  if echo "${PROFILES}" | grep -q "${PROFILE}"; then
    pactl set-card-profile "${CARD}" "${PROFILE}" && log_info "profile set: ${CARD} -> ${PROFILE}" || log_error "failed to set profile"
  else
    log_error "profile ${PROFILE} not available on card ${CARD}"
    log_info "available profiles: ${PROFILES}"
    exit 1
  fi
fi
