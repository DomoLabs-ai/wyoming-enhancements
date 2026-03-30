# Wyoming Enhancements Issue Triage Report

## Summary
Triaged 21 open issues and 4 open PRs (25 total) as of 2026-03.

| Category | Count |
|----------|-------|
| Fixable (code/script patch) | 15 |
| Upstream dependency (workaround documented) | 5 |
| User error (FAQ entry added) | 1 |
| PR merged | 3 |
| PR merged (with updated refs) | 1 |
| **Total** | **25** |

## Fixable Issues — Patched

| Issue | Category | Fix |
|-------|----------|-----|
| #58, #24 | DomoAudio setup | `scripts/post-install-domoaudio-client.sh` — systemd daemon-reload and enable |
| #54 | Audio quality | `scripts/configure-alsa-buffer.sh` — configurable ALSA buffer for USB audio |
| #50 | DomoAudio setup | `scripts/detect-alsa-output.sh` — auto-detect ALSA output device |
| #46 | Connectivity | `scripts/ensure-avahi.sh` — install avahi-daemon for mDNS discovery |
| #43 | DomoAudio setup | `scripts/configure-domoaudio-client.sh` — increase buffer for Wi-Fi latency |
| #41 | TTS | `scripts/fix-tts-ordering.sh` — add PulseAudio dependency to Wyoming service |
| #39 | DomoAudio setup | `scripts/install-domoaudio-client.sh` — ARM-aware libflac fallback |
| #37, #14 | Volume | `scripts/init-volume.sh` — initialize ALSA mixer levels |
| #33 | Compatibility | `scripts/detect-debian-version.sh` — Debian Bookworm package mapping |
| #31 | Audio | `scripts/validate-pulseaudio-profile.sh` — validate before profile switch |
| #23 | Audio quality | `scripts/setup-stream-separation.sh` — separate TTS and wake word streams |
| #22 | DomoAudio setup | `scripts/create-domoaudio-client-config.sh` — generate default config |
| #18 | Music playback | `scripts/play_music.sh` — fix music routing through domoaudio sink |

## Upstream Issues — Workarounds Documented

| Issue | Upstream Project | Workaround |
|-------|-----------------|------------|
| #40 | Raspberry Pi kernel | Pin kernel version; increase ALSA buffer |
| #32 | badaix/snapcast | Upgrade to 0.28.0; add systemd watchdog |
| #20 | PulseAudio | Switch to PipeWire; scheduled PA restart |
| #13 | XMOS firmware | Stream separation; lower TTS volume; speaker positioning |
| #25 | Home Assistant core | Deferred to Phase 8; use shell_command workaround |

See `docs/UPSTREAM_WORKAROUNDS.md` for full details.

## User Error — FAQ Added

| Issue | Resolution |
|-------|-----------|
| #21 | Wrong output device — set `WYOMING_AUDIO_OUTPUT=hw:X,Y` in config.env; use `aplay -l` to find devices |

## PR Disposition

| PR | Action | Details |
|----|--------|---------|
| #56 | Merged | Updated domoaudio version references to 0.28.0 |
| #52 | Merged | Fixed play_music YAML indentation (tabs → spaces) |
| #47 | Merged | Replaced hardcoded "pi" username with `$USER` in docs |
| #48 | Merged | Manual install docs merged, updated to reference `scripts/install-domoaudio-client.sh` |
