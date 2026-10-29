# Changelog

The release notes of Dolphin Davinci Audio Tools, newest first. Each section is the text of the
release on Gitea and GitHub and of its entry in `#changes` on the landing page (`docs/index.html`).

Release steps, in this order (the version lives only here and on the landing page):
1. Section here, before the tag, on a branch `release/X.Y.Z`: `## [X.Y.Z] — YYYY-MM-DD`, `### English`
   and `### Deutsch`, each with a lead, the groups New, Improved, Fixed and Note as `####` (Neu,
   Verbessert, Behoben, Hinweis), and the compare link. Check with `scripts/release-notes.sh --check`,
   read with `scripts/release-notes.sh X.Y.Z`.
2. Landing page `docs/index.html`: the same text as the newest entry in `#changes` (from the fourth
   entry on, older ones go into `details.changelog-more`), footer version; screenshots of visible
   changes from the demo world, only now, by hand (`demo/shots.json` says how), saved as
   `docs/shots/release-X.Y.Z-<name>-<lang>.webp`.
3. PR, reviewed by a new Claude agent (no PR-Agent here), the owner confirms the release; merge on Gitea.
4. Tag the merge commit, push to Gitea only: `git tag -a vX.Y.Z -m X.Y.Z <commit> && git push origin vX.Y.Z`.
5. Gitea release, notes only: `scripts/release-notes.sh X.Y.Z > notes.md && tea releases create --login
   git.arianw.de --repo shrippen/dolphin-davinci-audio-tools --tag vX.Y.Z --title "Dolphin DaVinci Audio
   Tools X.Y.Z" --note-file notes.md`.
6. GitHub, by hand (no release workflow, no files: `install.sh` runs from a clone): `gh release create
   vX.Y.Z -R shrippen/dolphin-davinci-audio-tools --title "Dolphin DaVinci Audio Tools X.Y.Z"
   --notes-file notes.md --verify-tag`.
7. `python3 ../shrippen.github.io/overview/tools/build-versions.py`, commit `docs/versions.json` there via PR.
8. Done when https://shrippen.github.io/dolphin-davinci-audio-tools/ and
   https://shrippen.github.io/versions.json show it.

The script is a copy of Kante's `tools/release-notes.sh`: change it only there, sync with
`../Kante/tools/sync-release-notes.sh "$PWD"`.

## [1.2.1] — 2026-09-20

### English

The conversions are grouped in their submenu again.

#### Fixed
- Dolphin showed the entries without their submenu (`X-KDE-Submenu`) after a KIO regression; KIO fixed it upstream, and the grouping is restored.

All changes: https://github.com/shrippen/dolphin-davinci-audio-tools/compare/v1.2.0...v1.2.1

### Deutsch

Die Umwandlungen stehen wieder gesammelt in ihrem Untermenü.

#### Behoben
- Dolphin zeigte die Einträge nach einem Fehler in KIO ohne ihr Untermenü (`X-KDE-Submenu`); KIO hat ihn behoben, die Gruppierung ist wieder da.

Alle Änderungen: https://github.com/shrippen/dolphin-davinci-audio-tools/compare/v1.2.0...v1.2.1

## [1.2.0] — 2026-08-12

### English

The audio conversions take any audio, not only AAC, and audio-only files can be converted too.

#### New
- Audio to WAV (.wav): turns any audio-only file into a standalone `.wav` and replaces the original.
- Audio-only files work with the FLAC and AAC conversions too (for example `.m4a` → `.flac`, audio → `.m4a`).

#### Improved
- FLAC and WAV conversions accept every audio codec FFmpeg reads, not only AAC; the menu entries are called Audio to FLAC / WAV / AAC instead of "AAC → …".
- DNx conversions skip audio-only files with a clearer message.

#### Note
- The scripts are renamed: `aac2flac_*` → `audio2flac_*`, `aac2wav_*` → `audio2wav_*`, `toaac_*` → `audio2aac_*`. Run `install.sh` again so Dolphin finds them.

All changes: https://github.com/shrippen/dolphin-davinci-audio-tools/compare/v1.1.0...v1.2.0

### Deutsch

Die Audio-Umwandlungen nehmen jeden Ton, nicht nur AAC, und auch reine Audiodateien lassen sich umwandeln.

#### Neu
- Audio zu WAV (.wav): macht aus jeder reinen Audiodatei eine eigenständige `.wav` und ersetzt das Original.
- Reine Audiodateien gehen auch mit den FLAC- und AAC-Umwandlungen (zum Beispiel `.m4a` → `.flac`, Audio → `.m4a`).

#### Verbessert
- FLAC- und WAV-Umwandlungen nehmen jeden Audio-Codec, den FFmpeg liest, nicht nur AAC; die Menüeinträge heißen Audio zu FLAC / WAV / AAC statt „AAC → …“.
- DNx-Umwandlungen überspringen reine Audiodateien mit einer klareren Meldung.

#### Hinweis
- Die Skripte heißen neu: `aac2flac_*` → `audio2flac_*`, `aac2wav_*` → `audio2wav_*`, `toaac_*` → `audio2aac_*`. `install.sh` erneut ausführen, damit Dolphin sie findet.

Alle Änderungen: https://github.com/shrippen/dolphin-davinci-audio-tools/compare/v1.1.0...v1.2.0

## [1.1.0] — 2026-08-10

### English

Converting many files shows one progress dialog with an estimate of the time left.

#### New
- One progress dialog for the whole batch instead of a new one per file, with the files still waiting in its label.
- A rough estimate of the time left, weighted by the length of every file in the queue.

#### Fixed
- The progress bar did not move and the dialog did not close (the D-Bus reference for `qdbus` was split wrongly).
- Media lengths are read the same in every locale, so progress and estimate are right with a decimal comma too.

All changes: https://github.com/shrippen/dolphin-davinci-audio-tools/compare/v1.0.0...v1.1.0

### Deutsch

Beim Umwandeln vieler Dateien gibt es einen Fortschrittsdialog mit einer Schätzung der Restzeit.

#### Neu
- Ein Fortschrittsdialog für den ganzen Stapel statt eines neuen je Datei, mit den noch wartenden Dateien in seiner Beschriftung.
- Eine grobe Schätzung der Restzeit, gewichtet nach der Länge jeder Datei in der Warteschlange.

#### Behoben
- Der Fortschrittsbalken bewegte sich nicht, und der Dialog schloss nicht (die D-Bus-Referenz für `qdbus` wurde falsch zerlegt).
- Medienlängen werden in jeder Sprache gleich gelesen, Fortschritt und Schätzung stimmen auch mit Dezimalkomma.

Alle Änderungen: https://github.com/shrippen/dolphin-davinci-audio-tools/compare/v1.0.0...v1.1.0

## [1.0.0] — 2026-08-10

### English

The first release: Dolphin service menus that turn audio and video into formats DaVinci Resolve on Linux can read, with native KDE dialogs.

#### New
- AAC → FLAC (replace in place or write `.mkv`), AAC → WAV keeping the container, to AAC with a fitting container (`.mp4` / `.mov`), and DNxHD / DNxHR SQ as `.mov`.
- Several selected files at once, with progress dialogs and desktop notifications.
- Install and uninstall scripts for common Linux distributions.
- Each result is checked before it replaces the original.

#### Improved
- Progress and confirmation dialogs use KDE's `kdialog` instead of GNOME's `zenity`.

#### Note
- Needs `kdialog` and `qdbus`/`qdbus6` instead of `zenity`.

All changes: https://github.com/shrippen/dolphin-davinci-audio-tools/compare/b75df40...v1.0.0

### Deutsch

Die erste Version: Dolphin-Dienstmenüs, die Ton und Video in Formate umwandeln, die DaVinci Resolve unter Linux lesen kann, mit nativen KDE-Dialogen.

#### Neu
- AAC → FLAC (an Ort und Stelle ersetzen oder `.mkv` schreiben), AAC → WAV mit gleichem Container, zu AAC mit passendem Container (`.mp4` / `.mov`) und DNxHD / DNxHR SQ als `.mov`.
- Mehrere ausgewählte Dateien auf einmal, mit Fortschrittsdialogen und Desktop-Benachrichtigungen.
- Skripte zum Installieren und Entfernen für verbreitete Linux-Distributionen.
- Jedes Ergebnis wird geprüft, bevor es das Original ersetzt.

#### Verbessert
- Fortschritts- und Bestätigungsdialoge nutzen KDEs `kdialog` statt GNOMEs `zenity`.

#### Hinweis
- Braucht `kdialog` und `qdbus`/`qdbus6` statt `zenity`.

Alle Änderungen: https://github.com/shrippen/dolphin-davinci-audio-tools/compare/b75df40...v1.0.0
