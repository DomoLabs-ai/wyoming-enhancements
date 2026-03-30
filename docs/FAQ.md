# Wyoming Enhancements FAQ

## DomoAudio

### DomoAudio Client fails to install on ARM
Run `scripts/install-domoaudio-client.sh` which handles libflac dependencies
automatically. Set `DOMO_AUDIO_CLIENT_VERSION` env var to pin a specific version.
Default version: 0.28.0.

### DomoAudio not playing music
1. Check output device: `scripts/detect-alsa-output.sh`
2. Generate config: `scripts/create-domoaudio-client-config.sh`
3. Restart: `systemctl restart domoaudio-client`
4. If still failing, check the domoaudio sink: `pactl list short sinks`

### Music playback routes to wrong output
Set `WYOMING_MUSIC_SINK=YourSinkName` in `/etc/wyoming-enhancements/config.env`.
The `play_music.sh` script will auto-detect the domoaudio sink, but you can
override it if multiple sinks are present.

### DomoAudio Client buffer underrun on Wi-Fi
Increase buffer: `DOMO_AUDIO_CLIENT_BUFFER_MS=500 scripts/configure-domoaudio-client.sh`
For wired connections, 150ms is usually sufficient.

### DomoAudio Client not starting after install
Run `scripts/post-install-domoaudio-client.sh` to daemon-reload and enable the service.

### Satellite not discovered by domoaudio-engine
Ensure avahi is installed: `scripts/ensure-avahi.sh`.
If using VLANs, configure an mDNS reflector on your router.

## Audio

### Audio crackling on USB DAC
Run `scripts/configure-alsa-buffer.sh` to set larger buffer sizes.
For persistent crackling, try `ALSA_BUFFER_SIZE=16384`.

### Volume too low / Mic gain too high
Run `scripts/init-volume.sh` to set default levels.
Override with `PLAYBACK_VOLUME=80%` and `CAPTURE_VOLUME=50%`.

### TTS not speaking after reboot
Run `scripts/fix-tts-ordering.sh` to ensure Wyoming starts after PulseAudio.

### Audio stuttering during voice response
Run `scripts/setup-stream-separation.sh` to separate TTS and wake word streams.
This creates dedicated PulseAudio sinks for TTS and wake word detection.

### No audio after switching PipeWire/PulseAudio
Run `scripts/detect-audio-system.sh` to auto-configure the correct audio backend.

### Wrong output device for TTS (#21)
Set `WYOMING_AUDIO_OUTPUT=hw:1,0` in `/etc/wyoming-enhancements/config.env`.
Use `aplay -l` to list available devices. Run `scripts/detect-alsa-output.sh`
to auto-detect the correct device.

### Echo/feedback during TTS playback
If using external USB speakers without onboard AEC, see
`docs/UPSTREAM_WORKAROUNDS.md` section on issue #13.

### Random audio device disconnects on RPi
This is a known kernel regression. See `docs/UPSTREAM_WORKAROUNDS.md` section on issue #40.

## PulseAudio

### Profile switch fails silently
Run `scripts/validate-pulseaudio-profile.sh` to check available profiles
before switching. Ensures bluetooth module is loaded.

### PulseAudio memory usage grows over time
Known leak in module-combine-sink. Switch to PipeWire or add a scheduled
restart. See `docs/UPSTREAM_WORKAROUNDS.md` section on issue #20.

## Compatibility

### Install fails on Debian Bookworm
Run `scripts/detect-debian-version.sh` first to configure the correct
package names for your Debian version.
