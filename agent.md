# Working rules for this repository

The rules for all shrippen repositories are in `RULES.md` (writing, code, commits, bug
fixes, repository, GUI). It is a synced copy from the rules repository; do not edit it
here. This file holds only what is particular to this repository. A Claude Code session on
the owner's machine has the rules through the global `CLAUDE.md` already and reads
`RULES.md` only for its GUI rule, before work on a user interface.

## Repository (this project)

- No CI: before a PR run `pipx run tools/structure-check.py` (limits in `structure.baseline`). The merge waits for a clean run and the review.
- Everything else: `RULES.md` (Repository) and the skill `pr-review`.
