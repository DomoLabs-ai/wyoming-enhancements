# Upstream Issue Workarounds

These issues depend on fixes in external projects. This document provides
temporary workarounds until upstream patches are available.

## #40 — Kernel ALSA Driver Regression (Raspberry Pi OS)
**Upstream:** Raspberry Pi kernel team
**Affected:** RPi 4/5 with USB audio on kernel 6.1.x+

**Symptoms:** Random ALSA device disconnects, `snd_usb_audio` errors in dmesg.

**Workaround:**
1. Pin kernel to last known-good version:
   ```bash
   sudo apt-mark hold raspberrypi-kernel
   ```
2. Or add to `/boot/config.txt`:
   ```
   dtoverlay=dwc2,dr_mode=host
   dwc_otg.fiq_fsm_enable=0
   ```
3. Use `scripts/configure-alsa-buffer.sh` with larger buffer sizes as mitigation.

**Tracking:** https://github.com/raspberrypi/linux/issues — search for snd_usb_audio regressions

---

## #32 — DomoAudio Engine Crash on Client Disconnect
**Upstream:** badaix/snapcast
**Affected:** DomoAudio Engine 0.27.x when domoaudio-client disconnects during active stream

**Symptoms:** DomoAudio Engine segfault, all clients lose audio simultaneously.

**Workaround:**
1. Upgrade to DomoAudio 0.28.0 (partial fix):
   ```bash
   DOMO_AUDIO_CLIENT_VERSION=0.28.0 scripts/install-domoaudio-client.sh
   ```
2. Add a systemd watchdog for domoaudio-engine:
   ```ini
   [Service]
   WatchdogSec=30
   Restart=always
   RestartSec=3
   ```
3. Use `scripts/domoaudio-watchdog.sh` (from orbit repo) for client-side recovery.

**Tracking:** https://github.com/badaix/snapcast/issues (check for fixes)

---

## #20 — PulseAudio Memory Leak in module-combine-sink
**Upstream:** PulseAudio / PipeWire
**Affected:** PulseAudio 16.x with module-combine-sink under sustained streaming

**Symptoms:** PulseAudio memory usage grows over hours, eventually OOM on 1GB RPi.

**Workaround:**
1. Switch to PipeWire (recommended for new installs):
   ```bash
   sudo apt install pipewire pipewire-pulse wireplumber
   systemctl --user enable --now pipewire pipewire-pulse
   ```
2. Or add a PulseAudio restart cron job:
   ```bash
   echo "0 */6 * * * systemctl --user restart pulseaudio" | crontab -
   ```
3. Run `scripts/detect-audio-system.sh` to auto-detect and configure.

---

## #13 — AEC Not Supported for External USB Speakers
**Upstream:** XMOS firmware / Wyoming protocol
**Affected:** Satellites using external USB speakers instead of onboard DAC

**Symptoms:** Echo cancellation (AEC) not effective, voice assistant hears
its own TTS output and re-triggers.

**Workaround:**
1. Use `scripts/setup-stream-separation.sh` to isolate TTS from wake word audio.
2. Lower TTS volume during active listening:
   ```bash
   PLAYBACK_VOLUME=50% scripts/init-volume.sh
   ```
3. Position the USB speaker away from the satellite microphone.
4. For XMOS-based satellites, AEC is handled in firmware — ensure firmware is
   updated to the latest version with AEC tuning (see `aec_tuning.cmake`).

---

## #25 — PulseAudio HA Integration
**Status:** Deferred to Phase 8
**Reason:** Requires Home Assistant core changes to expose PulseAudio controls
through the Wyoming protocol. Currently out of scope for wyoming-enhancements.

**Current alternative:**
- Use `shell_command` in HA to invoke volume control scripts:
  ```yaml
  shell_command:
    set_satellite_volume: >-
      ssh satellite "PLAYBACK_VOLUME={{ volume }}%"
      "/opt/wyoming-enhancements/scripts/init-volume.sh"
  ```
