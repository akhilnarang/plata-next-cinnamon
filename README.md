# Plata-Next for Cinnamon

[Plata](https://gitlab.com/tista500/plata-theme)'s Material Design look on top of
Cinnamon 6.6's own default theme. Plata's own Cinnamon theme stopped at Cinnamon ~4.6
(2020) and leaves many newer widgets unstyled. This port starts from the current
Cinnamon theme, so every widget stays styled, and restyles it with Plata's palette,
shapes and assets.

Two variants: **Plata-Next-Lumine** (light) and **Plata-Next-Noir** (dark).

## Build and install

Needs `sassc`, `python3`, `git`, and the original Plata theme installed in
`/usr/share/themes`. The build copies its GTK and window parts from there; this repo
only contains the Cinnamon desktop theme.

```bash
./build.sh                      # installs into ~/.themes
THEMES_DIR=/some/dir ./build.sh # or elsewhere
```

Then pick the same name for Applications and Desktop in System Settings → Themes.
`build.sh` also checks that every `url()` resolves and that no selector from the
upstream Cinnamon theme was lost (`check-selectors.py`).

## Credits

- **Cinnamon default theme** (`cinnamon-sass/`, the root-level SVG/PNG images):
  [linuxmint/cinnamon](https://github.com/linuxmint/cinnamon) 6.6.9, by the Linux Mint
  team and contributors. The first commit of this repo is that theme, unmodified.
- **Plata** (palette, design, `assets/`, `thumbnail-light.png`, `thumbnail-dark.png`):
  [tista500/plata-theme](https://gitlab.com/tista500/plata-theme) by tista500 and
  contributors. Plata itself builds on Nana-4's
  [Materia](https://github.com/nana-4/materia-theme) (formerly Flat-Plat).
- The Plata thumbnails show [Paper icons](https://snwh.org/paper/icons) by Sam Hewitt
  (CC BY-SA 4.0).

## Changes

Compared with the sources above: `_colors.scss` replaced with Plata's palette (light and
dark), drawing mixins and widget styles adjusted to Plata's shapes, contrast fixes for
light-variant text, and Plata's SVG assets added. See the git history for details.

## License

- Code (Sass, CSS, scripts): **GPL-2.0**, see [`COPYING`](COPYING). Cinnamon is
  GPL-2.0-or-later and Plata's code is GPL-2.0.
- Plata-derived images (`assets/`, `thumbnail-light.png`, `thumbnail-dark.png`):
  **CC BY-SA 4.0**, see [`LICENSE_CC_BY_SA4`](LICENSE_CC_BY_SA4). Cinnamon's own images
  stay under its GPL-2.0-or-later.
