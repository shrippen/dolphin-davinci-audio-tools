# Changelog

The release notes of Dolphin Davinci Audio Tools, newest first. Each section is the text of the
release on Gitea and GitHub and of its entry in `#changes` on the landing page (`docs/index.html`).

Release rule: before the tag, write the release log here (`## [X.Y.Z] — YYYY-MM-DD`, `### English`
and `### Deutsch`, each with a lead, the groups New, Improved, Fixed and Note as `####`, and the
compare link). Put the same text into the Gitea release notes and as the newest entry in `#changes`
(from the fourth entry on, older ones go into `details.changelog-more`), and bump the footer version.
A release is done when the landing page shows it.

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
