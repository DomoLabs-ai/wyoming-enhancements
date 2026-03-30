# DomoAudio Client Manual Installation

> **Note:** For most users, the automated installer is recommended:
> `sudo scripts/install-domoaudio-client.sh`

## Manual Steps (from PR #48)

These manual steps are preserved for reference and edge cases
where the automated installer is not suitable.

### 1. Check architecture
```bash
ARCH=$(dpkg --print-architecture)
echo "Architecture: $ARCH"
```

### 2. Install libflac dependency
```bash
# Debian Bookworm+
sudo apt-get install -y libflac-dev

# Debian Bullseye/Buster
sudo apt-get install -y libflac8
```

### 3. Download and install snapclient (domoaudio-client)
```bash
DOMO_AUDIO_CLIENT_VERSION=0.28.0
wget https://github.com/badaix/snapcast/releases/download/v${DOMO_AUDIO_CLIENT_VERSION}/snapclient_${DOMO_AUDIO_CLIENT_VERSION}-1_${ARCH}.deb
sudo dpkg -i snapclient_${DOMO_AUDIO_CLIENT_VERSION}-1_${ARCH}.deb
sudo apt-get install -f -y
```

### 4. Enable and start the service
```bash
sudo systemctl daemon-reload
sudo systemctl enable domoaudio-client.service
sudo systemctl start domoaudio-client.service
```

### 5. Configure (optional)
See `docs/DOMO_AUDIO_INSTALL.md` for configuration options and
`scripts/create-domoaudio-client-config.sh` for automated config generation.

## Automated Alternative
The automated installer handles all of the above plus:
- ARM architecture detection
- libflac dependency resolution and symlink fallback
- Debian version-aware package selection
- Retry logic with exponential backoff
- Post-install systemd configuration
