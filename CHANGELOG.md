# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-08-12

### Added

- **Audio to WAV (.wav)**: convert any audio-only file to a standalone `.wav` and replace the original
- Shared `lib_media_helpers.sh` for audio/video detection and safe replace helpers
- Audio-only support across FLAC/AAC conversions (e.g. `.m4a` → `.flac`, audio → `.m4a`)

### Changed

- Renamed scripts and menu entries from “AAC → …” to general **Audio to FLAC / WAV / AAC**
- FLAC and keep-container WAV conversions accept any input audio codec FFmpeg supports (not only AAC)
- DNx conversions skip audio-only files with a clearer message

### Renamed

- `aac2flac_*` → `audio2flac_*`
- `aac2wav_*` → `audio2wav_*`
- `toaac_*` → `audio2aac_*`

## [1.1.0] - 2026-08-10

### Added

- Single batch progress dialog for multi-file conversions (no longer reopens per file)
- Pending-file list in the progress dialog label
- Rough remaining-time (ETA) estimate weighted by media duration across the whole queue

### Fixed

- Progress bar updates and dialog close under `IFS=$'\n\t'` (D-Bus reference was not split correctly for `qdbus`)
- Locale-safe media duration parsing for progress/ETA calculations

## [1.0.0] - 2026-08-10

### Added

- KDE Dolphin service menus for Davinci Resolve–oriented audio/video conversions
- AAC → FLAC conversion (replace in place or output `.mkv`)
- AAC → WAV conversion with original container preserved
- To AAC conversion with smart container selection (`.mp4` / `.mov`)
- DNxHD / DNxHR SQ conversion for Davinci Resolve (`.mov`, replace or new file)
- Real-time progress dialogs and desktop notifications
- Batch processing for multiple selected files
- Installation and uninstallation scripts for common Linux distributions
- Output validation and safety checks before replacing originals

### Changed

- Progress and confirmation dialogs now use native KDE `kdialog` instead of GNOME `zenity`
- Dependencies updated accordingly (`kdialog`, `qdbus`/`qdbus6` instead of `zenity`)

[1.2.0]: https://github.com/shrippen/dolphin-davinci-audio-tools/releases/tag/v1.2.0
[1.1.0]: https://github.com/shrippen/dolphin-davinci-audio-tools/releases/tag/v1.1.0
[1.0.0]: https://github.com/shrippen/dolphin-davinci-audio-tools/releases/tag/v1.0.0
