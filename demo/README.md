# Demo (internal)

Internal tool for automated screenshots, not part of any release. Uses the shared demo world of all shrippen projects (shrippen.github.io/demo).

`demo/start.sh` creates demo files of Studio Weber, the demo world shared by all shrippen projects
(`demo/world.json`, copied from `shrippen.github.io/demo`): AAC/M4A interview and atmo recordings of
"Harbour Lights" and a short H.264 clip with AAC sound, generated with ffmpeg into `demo/media/`, and
opens them in Dolphin. `demo/start.sh convert` also runs one batch conversion with a real-time ffmpeg
(`demo/slow-ffmpeg.sh` via the `FFMPEG` variable, which every script now honours), so the progress
dialog stays open long enough for a screenshot.
