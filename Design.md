# Design Reference

This project follows the shared **shrippen Design Default** for all visual decisions.

**Source:** <https://github.com/shrippen/DesignDefault>

When making changes to the landing page, icons, badges, or any visual element,
consult the DesignDefault repository for the canonical palette, typography,
layout rules, and icon language.

## Quick palette reference

| Token       | Hex       | Role                          |
|-------------|-----------|-------------------------------|
| `bg-hard`   | `#1d2021` | Deepest background            |
| `bg0`       | `#282828` | Page background               |
| `bg1`       | `#3c3836` | Cards, elevated surfaces      |
| `bg2`       | `#504945` | Borders, dividers             |
| `fg0`       | `#fbf1c7` | Primary heading text          |
| `fg1`       | `#ebdbb2` | Body text                     |
| `fg2`       | `#d5c4a1` | Secondary / muted text        |
| `fg3`       | `#a89984` | Placeholder, disabled, footer |
| `accent`    | `#e8dcc4` | Brand warm-cream              |
| `blue`      | `#83a598` | Primary action, links         |
| `aqua`      | `#8ec07c` | Success, confirm              |
| `green`     | `#b8bb26` | Positive, badges              |
| `yellow`    | `#fabd2f` | Warnings                      |
| `orange`    | `#fe8019` | Active / highlight            |
| `red`       | `#fb4934` | Error, destructive            |
| `purple`    | `#d3869b` | Tags, categories              |

## Typography

- **Headings:** Rajdhani (600/700) via Google Fonts
- **Body:** System sans stack
- **Code:** JetBrains Mono / Fira Code / Cascadia Code

## Key rules

- Dark-only landing page, no light mode
- `--bg0` page, `--bg1` cards, `--bg-hard` hero/code blocks
- Links & primary buttons use `--blue`
- Max content width: 860px
- Feature grid: `auto-fit minmax(240px, 1fr)`
- Badges: shields.io with `labelColor=1c1c20`

For the full specification (icon language, Plasma widget rules, OG image format,
landing page template), see the [DesignDefault README](https://github.com/shrippen/DesignDefault).

## Known issues

### X-KDE-Submenu regression (KIO 6.29 / Plasma 6, August 2026)

`X-KDE-Submenu` in `.desktop` service menu files causes the **entire menu to
not appear** in Dolphin's context menu. Removing the key makes all actions show
at the top level again.

This is a regression — `X-KDE-Submenu` worked in earlier KF6 versions (confirmed
working on KF 6.14 / Plasma 6.3.5 by other users). No exact upstream bug report
exists yet for the "submenu completely invisible" variant. Related upstream bugs:

- [Bug 495740](https://bugs.kde.org/show_bug.cgi?id=495740) — Can't assign icon to submenu (open)
- [Bug 505571](https://bugs.kde.org/show_bug.cgi?id=505571) — Submenu icon ignored (open)
- [KDE Discuss: service menu ordering regression](https://discuss.kde.org/t/how-are-service-menus-ordered/40444)

**TODO:** Re-add `X-KDE-Submenu=Davinci Resolve Conversions` once the regression
is fixed upstream. Track KIO releases and test after each update.
