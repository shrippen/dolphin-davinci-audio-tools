#!/usr/bin/env bash
# Creates the demo media of Studio Weber (the shrippen demo world, demo/world.json): the AAC/M4A
# interview and atmo recordings of "Harbour Lights" and a short H.264 clip with AAC sound, the
# kind of files DaVinci Resolve on Linux cannot play. Generated with ffmpeg (tones and noise).
#   demo/make-media.sh [FOLDER]   (default: demo/media)
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="${1:-${HERE}/media}"
mkdir -p "${OUT}"
python3 - "${HERE}/world.json" <<'PY' | while IFS='|' read -r name seconds tone; do
import json, sys
for f in json.load(open(sys.argv[1]))["media"]["audio_files"]:
    print(f"{f['name']}|{f['seconds']}|{f['tone']}")
PY
    [[ -f "${OUT}/${name}" ]] && continue
    ffmpeg -loglevel error -f lavfi -i "sine=frequency=${tone}:duration=${seconds}" \
        -f lavfi -i "anoisesrc=color=pink:amplitude=0.05:duration=${seconds}" \
        -filter_complex "[0][1]amix=inputs=2,volume=2" -c:a aac -b:a 160k "${OUT}/${name}"
    echo "created ${name}"
done
clip="${OUT}/hl_s02e03_landungsbruecken_take4.mp4"
if [[ ! -f "${clip}" ]]; then
    ffmpeg -loglevel error -f lavfi -i "testsrc2=size=1280x720:rate=25:duration=20" \
        -f lavfi -i "sine=frequency=330:duration=20" -c:v libx264 -pix_fmt yuv420p -c:a aac -shortest "${clip}"
    echo "created $(basename "${clip}")"
fi
