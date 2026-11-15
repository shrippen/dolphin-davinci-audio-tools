# Review guide

Every PR is reviewed before it is merged (`RULES.md`). The reviewer knows nothing of the
session that wrote the change: it gets the PR's intent, its diff, the repository and this
file. The owner does not read code; this review is the second reader.

## What failure looks like here

Right-click entries in Dolphin turn the user's videos and sounds into files DaVinci Resolve
can read, with ffmpeg and kdialog. A bug that matters loses or damages the user's media:

- **Lost original:** the original deleted or overwritten before the result was checked
  (`is_valid_file`, not only "file exists"), or when ffmpeg failed, the result is empty, or
  a result of the same name already exists. A "new file" entry that touches the original.
- **Lost streams:** a video loses its subtitles, chapters, metadata, second audio track or
  video stream in a conversion (`-map`, `-map_metadata`), or the wrong stream is converted.
- **Wrong result:** FLAC, AAC or WAV with another rate or depth than the README names;
  DNxHD above 1080p or DNxHR at or below it; vertical video taken as horizontal; AAC
  made from AAC; a container that cannot hold the new sound.
- **Wrong name:** a new file that overwrites another instead of `name (1).ext`; an
  extension that does not match the content.
- **Bad file names:** spaces, quotes, `$`, newlines or a leading `-` in a selected file's
  name break a script, or run as part of a command.
- **Stuck or silent:** a batch that hangs, a progress dialog left open, a failure the user
  is not told about, a temporary file left beside the original.
- **Menu and scripts out of step:** an entry whose script is missing, not executable or
  not installed (`install.sh`); a menu text that says another thing than the script does.
- **Lies:** README, landing page or comments the code contradicts, e.g. a needed program
  listed that no script uses, or one that is used and not listed.

## What to check in particular

- Layers: as in `ARCHITECTURE.md`. A menu entry holds no logic; a format script calls no
  other script; the libraries do not know single formats; `scripts/` does not know `demo/`.
- Replacing an original happens in one place, after the result is checked. A new copy of
  that logic in a format script is **Wichtig**.
- Shell: every expansion quoted, `set` options and `trap` cleanup as in the neighbouring
  scripts, no `eval` on file names.
- There are no tests. A change to what a script decides (target name, DNx variant, when an
  original may go) is checked by reading the paths it takes. Say which input you followed.
- A new needed program: in `install.sh`, README and landing page together.
- GUI rule: the landing page (`docs/index.html`) uses Kante as it is, no own colours or
  fonts. The dialogs are kdialog and need nothing from Kante.
- Bug fixes: the cause removed. A test that failed before is wanted where the code can be
  tested; today there is no test setup.
- Structure: `pipx run tools/structure-check.py` is clean; no new entry in `structure.baseline`.

## What the owner confirms here

- A release, a tag, a change of the landing page's published text (`CHANGELOG.md`).
- Changes to the rule files (`agent.md`, `RULES.md`, `REVIEW.md`) and to `ARCHITECTURE.md`
  "Layers".

## Skip

- `tools/structure-check.py`, `RULES.md` and `scripts/release-notes.sh` (synced copies).
- Images in `docs/`, `demo/` media and `demo/world.json`.
- Style of the existing scripts that the diff does not touch (the audit covers it).

## How to report

- Every finding names file and line and the concrete input or state that goes wrong.
  No guess without evidence; if unsure, say so.
- Each finding gets one label: **Wichtig** (must be fixed or answered before the merge),
  **Kleinigkeit** (optional, at most five) or **Bestand** (was there before this PR).
- The report starts with the count, e.g. "2 Wichtig, 1 Kleinigkeit".
