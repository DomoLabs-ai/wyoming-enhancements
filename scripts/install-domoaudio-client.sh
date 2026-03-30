#!/bin/bash
source "$(dirname "$0")/lib/common.sh"
VER="${DOMO_AUDIO_CLIENT_VERSION:-0.28.0}"
ARCH="$(dpkg --print-architecture)"
log_info "DomoAudio Client ${VER} for ${ARCH}"
apt-get install -y --no-install-recommends snapclient 2>/dev/null && { ln -sf "$(command -v snapclient)" /usr/local/bin/domoaudio-client; log_info "installed from apt"; exit 0; }
apt-get install -y --no-install-recommends libflac-dev 2>/dev/null || true
lib="$(find /usr/lib/ -name 'libFLAC.so.*' -type f 2>/dev/null | head -1)"
tgt="/usr/lib/${ARCH}-linux-gnu/libFLAC.so.8"
[ -n "${lib}" ] && [ ! -e "${tgt}" ] && ln -sf "${lib}" "${tgt}"
deb="/tmp/snapclient.deb"
url="https://github.com/badaix/snapcast/releases/download/v${VER}/snapclient_${VER}-1_${ARCH}.deb"
retry 3 5 curl -fsSL -o "${deb}" "${url}"
dpkg --install --force-depends "${deb}" && apt-get install -f -y 2>/dev/null
rm -f "${deb}"
ln -sf "$(command -v snapclient)" /usr/local/bin/domoaudio-client
log_info "installed from deb"
