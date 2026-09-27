#!/usr/bin/env bash
# Demo of the service menu with the Studio Weber media (the shrippen demo world):
# creates the demo files (demo/make-media.sh), opens them in Dolphin and, with "convert",
# runs one batch conversion from the working tree with a real-time ffmpeg, so the progress
# dialog can be seen. Converted files land next to the demo files.
#   demo/start.sh [convert]
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
MEDIA="${HERE}/media"
"${HERE}/make-media.sh" "${MEDIA}"
if [[ "${1:-}" == "convert" ]]; then
    FFMPEG="${HERE}/slow-ffmpeg.sh" "${HERE}/../scripts/audio2wav" "${MEDIA}"/*.m4a &
fi
dolphin --new-window "${MEDIA}" >/dev/null 2>&1 &
echo "Demo files in ${MEDIA}; right-click them for the Davinci Resolve Conversions submenu"
echo "(the service menu must be installed: ./install.sh)."
