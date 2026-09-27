#!/usr/bin/env bash
# ffmpeg that reads its input in real time (-re), so a demo conversion takes as long as the clip
# and the progress dialog stays open long enough to look at. Used by demo/start.sh via FFMPEG.
exec /usr/bin/ffmpeg -re "$@"
