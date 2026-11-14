# Architecture

How this repository is meant to be built. Where the code differs today is listed under
"Known deviations". Change this file in the PR that changes the structure.

## What it does

Right-click entries for the file manager Dolphin: they convert the selected video and audio
files with ffmpeg into formats DaVinci Resolve on Linux can read (FLAC, WAV or AAC sound,
DNxHD/DNxHR video), each either as a new file or in place of the original.

## Building blocks

| Path | Its one task |
|---|---|
| `servicemenus/` | The menu: one entry per conversion, each starts one conversion script with the selected files. |
| `scripts/<conversion>` | One conversion each (eight today): which files it takes, the ffmpeg options, the name of the result, new file or replace. |
| `scripts/lib_media_helpers.sh` | What every conversion needs to know about a file: is it readable, what streams it has, a free file name, putting a result in place of the original. |
| `scripts/lib_batch_progress.sh` | The progress dialog for a batch: opens it, runs ffmpeg under it, shows the remaining time, closes it. |
| `scripts/release-notes.sh` | Release notes from `CHANGELOG.md`; a copy Kante syncs under exactly this path. Not installed. |
| `install.sh`, `uninstall.sh` | Check the needed programs, copy menu and scripts into the user's folders, remove them again. |
| `demo/` | Demo media and a slowed-down ffmpeg for screenshots. Not in a release archive. |
| `docs/` | The landing page. |
| `tools/` | The structure check, a synced copy from the rules repository. |

## Layers

```
 Dolphin ─► servicemenus/*.desktop ─► scripts/<conversion>
                                          │            │
                                          ▼            ▼
                         lib_media_helpers.sh    lib_batch_progress.sh
                          (ffprobe, files)        (dialog, runs ffmpeg)

 install.sh ─► copies servicemenus/ and scripts/         demo/ ─► scripts/<conversion>
```

- A menu entry starts exactly one conversion script; the menu holds no logic.
- A conversion script holds only what is particular to it: which files it accepts, its
  ffmpeg options, the name of its result.
- Everything two conversions share lives in one of the two libraries, once: reading a
  file's properties and replacing an original in `lib_media_helpers.sh`, the dialog and
  the ffmpeg run in `lib_batch_progress.sh`.
- An original is deleted or overwritten in one place only, after the result was checked;
  no conversion script does it by hand.
- The libraries do not know the single conversions, and no conversion script calls
  another.
- `install.sh` installs the menu, every conversion script and both libraries as they lie
  in the repository; it keeps no list of its own that must match them.
- `demo/` uses the scripts from outside; nothing in `scripts/` knows the demo.

## Where new things go

| Change | Touch |
|---|---|
| A new conversion | A new `scripts/<conversion>`, its entry in `servicemenus/`, the list in `install.sh` (until the deviation below is gone), README and landing page |
| Other ffmpeg options for one format | That `scripts/<conversion>` only |
| A new check on a file (stream, codec, size) | `scripts/lib_media_helpers.sh` |
| When an original may be replaced | `scripts/lib_media_helpers.sh` only |
| The progress dialog or the remaining-time text | `scripts/lib_batch_progress.sh` |
| A new needed program | `install.sh`, README, landing page |
| A release | `CHANGELOG.md`, landing page (skill `release-changelog`) |

## Known deviations

- Five scripts replace the original by hand, with differing checks before
  (`AUDIT.md`, finding 1).
- The two DNx scripts do not use `lib_media_helpers.sh` and carry their own copies; the
  duration of a file is read in `lib_batch_progress.sh` (`AUDIT.md`, finding 2).
- The two DNx scripts are copies of each other up to their ending (`AUDIT.md`, finding 3).
- All eight conversions repeat the same frame around their ffmpeg call
  (`AUDIT.md`, finding 4).
- `install.sh` keeps its own list of scripts (`AUDIT.md`, finding 7).
- There are no tests (`AUDIT.md`, finding 5).
