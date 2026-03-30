#!/bin/bash
source "$(dirname "$0")/lib/common.sh"
BUFFER_MS="${DOMO_AUDIO_CLIENT_BUFFER_MS:-300}"
CONNECTION_TYPE="${CONNECTION_TYPE:-wifi}"
if [ "${CONNECTION_TYPE}" = "wired" ]; then
  BUFFER_MS="${DOMO_AUDIO_CLIENT_BUFFER_MS:-150}"
fi
log_info "configuring domoaudio-client: buffer_ms=${BUFFER_MS} (${CONNECTION_TYPE})"
CONF_DIR="/etc/default"
mkdir -p "${CONF_DIR}"
echo "DOMO_AUDIO_CLIENT_OPTS=\"--buffer_ms=${BUFFER_MS} --latency=0\"" > "${CONF_DIR}/domoaudio-client"
log_info "domoaudio-client configured at ${CONF_DIR}/domoaudio-client"
systemctl restart domoaudio-client.service 2>/dev/null || true
