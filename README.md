# Dolphin Davinci Audio Tools

**KDE Dolphin service menus for audio/video conversion optimized for Davinci Resolve on Linux**

## Overview

Dolphin Davinci Audio Tools provides right-click context menu options in KDE Dolphin to convert video files for compatibility with Davinci Resolve on Linux. Since Davinci Resolve on Linux doesn't support AAC audio natively, this tool makes it easy to convert your files to professional formats that work seamlessly.

### Problem Solved

- **Davinci Resolve Limitation**: Cannot handle AAC audio streams in video files
- **Linux Solution**: Easy conversion to compatible formats without leaving the file manager
- **Professional Codecs**: Support for industry-standard DNxHD/DNxHR intra-frame codecs

### Key Features

- **Audio Conversions**: Convert audio to FLAC, WAV, or AAC — any input codec FFmpeg supports
- **Davinci Resolve Codecs**: DNxHD (≤1080p) and DNxHR SQ (>1080p) with smart resolution detection
- **Container Support**: Professional .mov containers for DNx codecs
- **Progress Tracking**: Single batch dialog with pending files and duration-based ETA
- **Batch Processing**: Convert multiple files simultaneously
- **Metadata Preservation**: Maintains video streams, subtitles, chapters, and metadata
- **Orientation Support**: Works with both horizontal and vertical video content

## Dependencies

You must install these dependencies before using the tool:

### Ubuntu/Debian
```bash
sudo apt install ffmpeg kdialog qdbus-qt5 libnotify-bin bc
```

### Fedora/CentOS/RHEL
```bash
sudo dnf install ffmpeg kdialog qt6-qttools libnotify bc
```

### Arch Linux
```bash
sudo pacman -S ffmpeg kdialog qt6-tools libnotify bc
```

### openSUSE
```bash
sudo zypper install ffmpeg kdialog libqt6-qttools libnotify-tools bc
```

### Other Distributions
- **ffmpeg**: For video/audio conversion
- **kdialog**: For native KDE progress and confirmation dialogs
- **qdbus / qdbus6**: Qt D-Bus tools (required to update kdialog progress bars)
- **libnotify/notify-send**: For desktop notifications
- **bc**: For mathematical calculations in progress tracking

## Installation

### Automatic Installation (Ubuntu/Debian & Arch Linux)
```bash
cd dolphin-davinci-audio-tools
chmod +x install.sh
./install.sh
```

The installer will:
1. Check for missing dependencies
2. Offer to install them automatically on Ubuntu/Debian and Arch Linux systems
3. Install service menus to the correct Dolphin location
4. Set proper permissions
5. Display usage instructions

**Supported distributions for automatic installation:**
- Ubuntu/Debian and derivatives (Linux Mint, Pop!_OS, etc.)
- Arch Linux and derivatives (Manjaro, EndeavourOS, Garuda, etc.)

### Manual Installation (All Distributions)
1. Install dependencies manually (see above)
2. Create the service menu directory:
   ```bash
   mkdir -p ~/.local/share/kio/servicemenus
   ```
3. Copy service menu files:
   ```bash
   cp servicemenus/*.desktop ~/.local/share/kio/servicemenus/
   chmod +x ~/.local/share/kio/servicemenus/*.desktop
   ```
4. Copy scripts to a user-accessible location:
   ```bash
   mkdir -p ~/.local/share/dolphin-davinci-audio-tools
   cp scripts/* ~/.local/share/dolphin-davinci-audio-tools/
   chmod +x ~/.local/share/dolphin-davinci-audio-tools/*
   ```

5. Restart Dolphin to reload service menus:
   ```bash
   kquitapp5 dolphin && dolphin
   ```

## Usage

After installation, simply right-click on video or audio files in Dolphin and select **"Davinci Resolve Conversions"** from the context menu.

### Available Conversions

#### Audio Conversions
- **Audio to FLAC (delete original file)**: Any audio → FLAC (16-bit, 48kHz), replaces original
  - Video files → `.mkv`; audio-only (e.g. `.m4a`, `.mp3`) → `.flac`
- **Audio to FLAC (new file)**: Any audio → FLAC, creates new file, preserves original
  - Video → new `.mkv`; audio-only → new `.flac`
- **Audio to WAV (replace, keep container)**: Any audio in a **video file** → PCM in the original container (for Resolve proxies)
  - Skips audio-only files (use “Audio to WAV (.wav)” instead)
- **Audio to WAV (.wav, delete original file)**: Any audio-only file → standalone `.wav`, replaces original
- **Audio to AAC (replace original)**: Any non-AAC audio → AAC (192kb/s, 48kHz), replaces original
  - Video → same container (`.mp4`/`.mov`); audio-only → `.m4a`
- **Audio to AAC (new file)**: Any non-AAC audio → AAC, creates new file
  - Video → `.mp4`/`.mov`; audio-only → `.m4a`

#### Davinci Resolve Video Conversions
- **Convert to DNxHD/DNxHR (replace)**: Any resolution → appropriate intra-frame codec, replaces original file
- **Convert to DNxHD/DNxHR (.mov)**: Any resolution → appropriate intra-frame codec, creates new .mov file, preserves original
- Skips audio-only files (requires a video stream)

*Note: The "to_davinci_resolve" scripts automatically convert to DNxHD (≤1080p) or DNxHR SQ (>1080p) based on video resolution.*

### Smart Container Selection

The tool automatically selects the best container format for optimal compatibility:

- **FLAC Conversions**: Video → `.mkv`; audio-only → `.flac`
- **DNxHD/DNxHR Conversions**: Creates .mov files for professional standards (required by DNx codecs)
- **AAC Conversions**: Video → `.mp4`/`.mov`; audio-only → `.m4a`
- **WAV Conversions**: Audio-only → `.wav`; video proxies → PCM in original container

**File Extension Changes**:
- Replace options may change file extensions for compatibility (e.g. `track.m4a` → `track.flac`, `video.mov` → `video.mkv`)
- Original files are backed up temporarily during replacement, then safely removed

### Smart Resolution Detection

The tool automatically detects video resolution and selects the optimal codec:

- **DNxHD**: Used for content with ≤1080p total pixels (1920×1080 or 1080×1920)
- **DNxHR SQ**: Used for content with >1080p total pixels (4K and above, any orientation)

**Mixed Resolution Support**: Select multiple files with different resolutions (HD + 4K) and convert them all at once - each file automatically gets the appropriate codec for its resolution.

### Progress Tracking

All conversions include:
- **Single Batch Dialog**: One progress window for the whole selection (does not reopen per file)
- **Pending File List**: Shows remaining conversions in the dialog label
- **Duration-based ETA**: Rough remaining time weighted by media length, not file count
- **Desktop Notifications**: Success/failure notifications when each file completes
- **Error Handling**: Comprehensive error checking and user feedback

## File Format Details

### Audio Codecs
- **FLAC**: Lossless audio, ideal for archival and professional editing
- **AAC**: High-quality compressed audio (192kb/s, 48kHz, stereo)
- **Sample Rate**: All conversions use 48kHz for professional video compatibility

### Video Codecs
- **DNxHD**: Intra-frame codec for ≤1080p content (industry standard)
- **DNxHR SQ**: Scalable codec for >1080p content (4K, 8K, etc.)
- **Compression**: Intra-frame for frame-by-frame editing precision
- **Color Space**: YUV 4:2:2 for professional color grading

### Container Formats
- **.mov**: Professional container for DNxHD/HR (recommended for Davinci Resolve)
- **.mkv**: Open container for audio conversions
- **.mp4**: Standard container for AAC conversions

## Supported File Types

### Input Formats
- **Video**: All formats supported by FFmpeg (.mp4, .mkv, .mov, .avi, etc.)
- **Audio**: All formats supported by FFmpeg (.aac, .flac, .wav, .mp3, etc.)

### Output Formats
- **Video**: .mov (DNxHD/HR), .mkv (FLAC in video)
- **Audio**: .flac, .wav, .m4a (AAC), .mp4/.mov (AAC in video)

## Examples

### Converting Audio for Davinci Resolve
1. Right-click on a video or audio file
2. Select **Davinci Resolve Conversions** → **Audio to FLAC (new file)**
3. Wait for conversion to complete
4. Use the new file in Davinci Resolve with fully compatible audio

### Converting 4K Video to Professional Codec
1. Right-click on 4K video file
2. Select "Davinci Resolve Conversions" → "Convert to DNxHD/DNxHR (.mov)"
3. The tool automatically detects 4K resolution and applies DNxHR SQ
4. Result: Professional-grade video ready for editing

## Troubleshooting

### Common Issues

#### Service Menu Not Appearing
```bash
# Restart Dolphin
kquitapp5 dolphin && dolphin

# Check service menu installation
ls -la ~/.local/share/kio/servicemenus/
```

**Note**: Service menu validation warnings are normal and don't affect functionality. KDE service menus use different standards than regular .desktop files.

#### Dependency Issues
```bash
# Verify all dependencies are installed
which ffmpeg kdialog notify-send bc
which qdbus6 || which qdbus

# Test FFmpeg functionality
ffmpeg -version
```

#### Permission Errors
```bash
# Make sure scripts are executable
chmod +x ~/.local/share/dolphin-davinci-audio-tools/*
chmod +x ~/.local/share/kio/servicemenus/*.desktop
```

#### Conversion Failures
- Check system logs: `journalctl -r`
- Verify file permissions and disk space
- Ensure source files aren't corrupted

## Uninstallation

### Automatic Uninstallation
```bash
cd dolphin-davinci-audio-tools
chmod +x uninstall.sh
./uninstall.sh
```

### Manual Uninstallation
```bash
# Remove service menus
rm ~/.local/share/kio/servicemenus/dolphin-davinci-conversions.desktop

# Remove scripts
rm -rf ~/.local/share/dolphin-davinci-audio-tools

# Restart Dolphin
kquitapp5 dolphin && dolphin
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

This project is provided as-is for educational and personal use. Please ensure you have appropriate rights to convert and modify any media files.

## Contributing

Contributions are welcome! When submitting changes:
1. Test thoroughly with various file formats and resolutions
2. Ensure compatibility across different Linux distributions
3. Follow existing code style and conventions
4. Update documentation as needed
