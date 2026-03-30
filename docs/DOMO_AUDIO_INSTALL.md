# DomoAudio Installation Guide

## Prerequisites
- Debian/Ubuntu-based OS (Bookworm or later recommended)
- ARM64 or AMD64 architecture

## Quick Install
```bash
sudo scripts/install-domoaudio-client.sh
```

## Manual Install
```bash
DOMO_AUDIO_CLIENT_VERSION=0.28.0
ARCH=$(dpkg --print-architecture)
wget https://github.com/badaix/snapcast/releases/download/v${DOMO_AUDIO_CLIENT_VERSION}/snapclient_${DOMO_AUDIO_CLIENT_VERSION}-1_${ARCH}.deb
sudo dpkg -i snapclient_${DOMO_AUDIO_CLIENT_VERSION}-1_${ARCH}.deb
sudo ln -sf $(command -v snapclient) /usr/local/bin/domoaudio-client
sudo apt-get install -f -y
```

## Configuration
After installation, run:
```bash
sudo scripts/create-domoaudio-client-config.sh
sudo scripts/post-install-domoaudio-client.sh
```

## Version History
| Version | Status | Notes |
|---------|--------|-------|
| 0.28.0 | Recommended | Current stable, libflac fix included |
| 0.27.0 | Supported | Requires manual libflac symlink on ARM |
| 0.26.0 | Deprecated | Known Wi-Fi buffer issues |
