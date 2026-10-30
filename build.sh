#!/usr/bin/env bash
# Build Plata-Next (Cinnamon 6.6 default theme restyled as Plata) and install
# ~/.themes/Plata-Next-Lumine (light) and ~/.themes/Plata-Next-Noir (dark).
# GTK/metacity parts are copied from the installed Plata-Lumine / Plata-Noir.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
themes="${THEMES_DIR:-$HOME/.themes}"
build="$here/build"

rm -rf "$build"
mkdir -p "$build"

install_variant() {
  local variant=$1 name=$2 plata=$3
  local src="/usr/share/themes/$plata" final="$themes/$name"
  local dest="$themes/.$name.new"  # staged; swapped in only after it validates
  local css="$build/cinnamon-$variant.css"

  for d in gtk-2.0 gtk-3.0 gtk-3.22 gtk-3.24 metacity-1; do
    [[ -d "$src/$d" ]] || { echo "missing $src/$d (install plata-theme)" >&2; exit 1; }
  done

  sassc -t expanded "$here/cinnamon-sass/cinnamon-$variant.scss" "$css"

  rm -rf "$dest"
  mkdir -p "$dest/cinnamon"
  cp "$css" "$dest/cinnamon/cinnamon.css"
  cp -a "$here/assets/$variant" "$dest/cinnamon/assets"
  cp "$here/thumbnail-$variant.png" "$dest/cinnamon/thumbnail.png"

  for d in gtk-2.0 gtk-3.0 gtk-3.22 gtk-3.24 metacity-1; do
    cp -a "$src/$d" "$dest/$d"
  done

  cat > "$dest/index.theme" <<EOF
[Desktop Entry]
Type=X-GNOME-Metatheme
Name=$name
Comment=Plata ($plata) rebased on the Cinnamon 6.6 default theme
Encoding=UTF-8

[X-GNOME-Metatheme]
Type=X-GNOME-Metatheme
GtkTheme=$name
MetacityTheme=$name
IconTheme=Adwaita
CursorTheme=Adwaita
EOF

  # every url() must resolve relative to the css
  local missing=0
  while read -r u; do
    [[ -f "$dest/cinnamon/$u" ]] || { echo "MISSING: $name/cinnamon/$u" >&2; missing=1; }
  done < <(grep -oE 'url\("?[^")]+"?\)' "$dest/cinnamon/cinnamon.css" | sed -E 's/url\("?([^")]+)"?\)/\1/' | sort -u)
  (( missing == 0 )) || { rm -rf "$dest"; exit 1; }
  rm -rf "$final"
  mv "$dest" "$final"
  echo "installed $final ($(grep -c '{' "$final/cinnamon/cinnamon.css") rules)"
}

install_variant light Plata-Next-Lumine Plata-Lumine
install_variant dark Plata-Next-Noir Plata-Noir

# no upstream (Cinnamon 6.6.9) selector may be lost: compare with the pristine first commit
upstream_rev=$(git -C "$here" rev-list --max-parents=0 HEAD)
mkdir -p "$build/upstream"
git -C "$here" archive "$upstream_rev" cinnamon-sass | tar -x -C "$build/upstream"
sassc "$build/upstream/cinnamon-sass/cinnamon.scss" "$build/upstream.css"
python3 "$here/check-selectors.py" "$build/upstream.css" "$build"/cinnamon-{light,dark}.css
echo "all upstream selectors present"
