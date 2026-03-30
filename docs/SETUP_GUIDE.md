# Wyoming Enhancements Setup Guide

## Installation

### 1. Clone the repository
```bash
cd /home/$USER
git clone https://github.com/FutureProofHomes/wyoming-enhancements.git
cd wyoming-enhancements
```

### 2. Run the installer
```bash
sudo ./install.sh
```

### 3. Configure audio
```bash
sudo scripts/detect-audio-system.sh
sudo scripts/init-volume.sh
```

### 4. Install domoaudio-client (optional, for multi-room audio)
```bash
sudo scripts/install-domoaudio-client.sh
sudo scripts/create-domoaudio-client-config.sh
sudo scripts/post-install-domoaudio-client.sh
```

### 5. Configure systemd services
```bash
sudo cp systemd/wyoming-enhancements.service.hardened /etc/systemd/system/wyoming-enhancements.service
sudo systemctl daemon-reload
sudo systemctl enable wyoming-enhancements
sudo systemctl start wyoming-enhancements
```

### 6. Verify installation
```bash
systemctl status wyoming-enhancements
systemctl status wyoming-satellite
journalctl -u wyoming-satellite --no-pager -n 20
```

## File Locations
| Path | Description |
|------|-------------|
| `/home/$USER/wyoming-enhancements/` | Application root |
| `/etc/wyoming-enhancements/` | Configuration files |
| `/etc/default/domoaudio-client` | DomoAudio Client defaults |
| `/var/log/wyoming-enhancements/` | Log files |

## Environment Variables
| Variable | Default | Description |
|----------|---------|-------------|
| `WYOMING_AUDIO_OUTPUT` | auto-detect | ALSA output device (e.g. `hw:1,0`) |
| `WYOMING_MUSIC_SINK` | `DomoAudio` | PulseAudio sink for music playback |
| `PLAYBACK_VOLUME` | `75%` | Initial playback volume |
| `CAPTURE_VOLUME` | `60%` | Initial capture/mic volume |
| `DOMO_AUDIO_CLIENT_VERSION` | `0.28.0` | DomoAudio Client version to install |
| `DOMO_AUDIO_CLIENT_BUFFER_MS` | `300` | DomoAudio Client buffer (ms) |
| `ALSA_PERIOD_SIZE` | `1024` | ALSA period size |
| `ALSA_BUFFER_SIZE` | `8192` | ALSA buffer size |
