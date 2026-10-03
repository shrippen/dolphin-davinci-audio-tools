#!/usr/bin/env bash
# Creates the demo media of Studio Weber (the shrippen demo world, demo/world.json): the AAC/M4A
# interview and atmo recordings of "Harbour Lights" and short H.264 clips with AAC sound, the
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
python3 - "${HERE}/world.json" <<'PY' | while IFS='|' read -r name seconds tone size rate; do
import json, sys
for f in json.load(open(sys.argv[1]))["media"]["video_files"]:
    print(f"{f['name']}|{f['seconds']}|{f['tone']}|{f['size']}|{f['rate']}")
PY
    [[ -f "${OUT}/${name}" ]] && continue
    ffmpeg -loglevel error -f lavfi -i "testsrc2=size=${size}:rate=${rate}:duration=${seconds}" \
        -f lavfi -i "sine=frequency=${tone}:duration=${seconds}" -c:v libx264 -pix_fmt yuv420p -c:a aac -shortest "${OUT}/${name}"
    echo "created ${name}"
done
