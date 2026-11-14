# Architecture

How this repository is meant to be built. Where the code differs today is listed under
"Known deviations". Change this file in the PR that changes the structure.

## What it does

Right-click entries for the file manager Dolphin: they convert the selected video and audio
files with ffmpeg into formats DaVinci Resolve on Linux can read (FLAC or WAV sound,
DNxHD/DNxHR video), and Resolve's sound back into AAC; FLAC, AAC and DNx either as a new
file or in place of the original, WAV always in place.

## Building blocks

| Path | Its one task |
|---|---|
| `servicemenus/` | The menu: one entry per thing the user can choose, each starts one format's script with the selected files. |
| `scripts/<format>` | One format each (FLAC, WAV, AAC, DNx): which files it takes, the ffmpeg options, the name of the result. Where the menu offers a choice, its entry tells the script which. |
| `scripts/lib_media_helpers.sh` | What every conversion needs to know about a file: is it readable, what streams it has, a free file name, putting a result in place of the original. |
| `scripts/lib_batch_progress.sh` | The run of a batch: queues the files, opens the progress dialog, runs ffmpeg under it, shows the remaining time, reports a failure, cleans up. |
| `scripts/release-notes.sh` | Release notes from `CHANGELOG.md`; a copy Kante syncs under exactly this path. Not installed. |
| `install.sh`, `uninstall.sh` | Check the needed programs, copy menu and scripts into the user's folders, remove them again. |
| `demo/` | Demo media and a slowed-down ffmpeg for screenshots. Not in a release archive. |
| `docs/` | The landing page. |
| `tools/` | The structure check, a synced copy from the rules repository. |

## Layers

```
 Dolphin ─► servicemenus/*.desktop ─► scripts/<format>  (with the choice)
                                          │            │
                                          ▼            ▼
                         lib_media_helpers.sh    lib_batch_progress.sh
                          (ffprobe, files)        (the run of a batch)

 install.sh ─► copies servicemenus/ and scripts/         demo/ ─► scripts/<format>
```

- A menu entry starts exactly one format script; the menu holds no logic.
- There is one script per format. It holds what is particular to the format, once: which
  files it accepts, its ffmpeg options, the name of its result. A choice the menu offers
  is a way through the same script, not a script of its own: "new file" or "replace" for
  FLAC, AAC and DNx; for WAV, which always replaces, "a sound file becomes .wav" or "a
  video keeps its container and gets WAV sound".
- Everything two formats share lives in one of the two libraries, once: reading a file's
  properties and replacing an original in `lib_media_helpers.sh`, the run of a batch
  (queue, dialog, ffmpeg, messages, cleanup) in `lib_batch_progress.sh`.
- An original is deleted or overwritten in one place only, after the result was checked;
  no format script does it by hand.
- The libraries do not know the single formats, and no format script calls another.
- `install.sh` installs the menu, every format script and both libraries as they lie in
  the repository; it keeps no list of its own that must match them.
- The needed programs are listed once, in `install.sh`; README and landing page point
  there.
- `demo/` uses the scripts from outside; nothing in `scripts/` knows the demo.

## Where new things go

| Change | Touch |
|---|---|
| A new format | A new `scripts/<format>`, its entries in `servicemenus/`, the list in `install.sh` (until the deviation below is gone), README and landing page |
| Other ffmpeg options for one format | That `scripts/<format>` only (today: both scripts of the pair) |
| A new check on a file (stream, codec, size) | `scripts/lib_media_helpers.sh` |
| When an original may be replaced | `scripts/lib_media_helpers.sh` only |
| The progress dialog or the remaining-time text | `scripts/lib_batch_progress.sh` |
| A new needed program | `install.sh` (today also README and landing page) |
| A release | `CHANGELOG.md`, landing page (skill `release-changelog`) |

## Known deviations

- Five scripts replace the original by hand, with differing checks before
  (`AUDIT.md`, finding 1).
- The two DNx scripts do not use `lib_media_helpers.sh` and carry their own copies; the
  duration of a file is read in `lib_batch_progress.sh` (`AUDIT.md`, finding 2).
- Every format has two scripts, one per menu entry (eight in all). The FLAC, AAC and DNx
  pairs repeat the format's checks and ffmpeg options, the DNx pair most
  (`AUDIT.md`, findings 3 and 4); the names of the WAV pair do not say what sets the two
  apart (`AUDIT.md`, finding 6). To be solved by one script per format, not by a shared
  file per pair or new names as the findings propose.
- All eight scripts repeat the run of a batch around their ffmpeg call instead of leaving
  it to `lib_batch_progress.sh` (`AUDIT.md`, finding 4).
- `install.sh` keeps its own list of scripts (`AUDIT.md`, finding 7).
- The needed programs are listed in four places, and `bc` is demanded though no script
  uses it (`AUDIT.md`, finding 8).
- There are no tests (`AUDIT.md`, finding 5).
