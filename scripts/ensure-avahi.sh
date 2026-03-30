#!/bin/bash
source "$(dirname "$0")/lib/common.sh"
log_info "checking avahi-daemon for mDNS discovery"
if command -v avahi-daemon &>/dev/null; then
  log_info "avahi-daemon already installed"
else
  log_info "installing avahi-daemon"
  apt-get update -qq
  apt-get install -y --no-install-recommends avahi-daemon avahi-utils 2>/dev/null
fi
systemctl enable avahi-daemon.service 2>/dev/null || true
systemctl start avahi-daemon.service 2>/dev/null || log_warn "avahi-daemon not started"
log_info "avahi-daemon ready"
