#!/bin/bash
source "$(dirname "$0")/lib/common.sh"
log_info "post-install: configuring domoaudio-client service"
require_cmd systemctl
systemctl daemon-reload
systemctl enable domoaudio-client.service 2>/dev/null || true
systemctl start domoaudio-client.service 2>/dev/null || log_warn "domoaudio-client not started (may need config first)"
log_info "domoaudio-client service enabled and started"
