#!/bin/bash
# Install screensaver-fx. Default effect: matrix (or the one given as $1).

set -euo pipefail
cd "$(dirname "$0")"

MENU="$HOME/.config/omarchy/extensions/omarchy-menu.jsonc"

# Only the ttfx wrapper needs to live outside $HOME: /usr/local/bin is the one
# PATH entry ahead of /usr/bin that the screensaver sees and updates never touch.
sudo install -Dm755 bin/ttfx /usr/local/bin/ttfx
install -Dm755 bin/screensaver-fx "$HOME/.local/bin/screensaver-fx"

# Keep an existing choice on reinstall
if [[ ! -f $HOME/.config/omarchy/screensaver-fx.conf ]]; then
  "$HOME/.local/bin/screensaver-fx" set "${1:-matrix}"
fi

# Menu: Style > Screensaver > Effect (the extension file hot-reloads)
if [[ -f $MENU ]]; then
  sed -i '/\/\/ >>> screensaver-fx/,/\/\/ <<< screensaver-fx/d' "$MENU"
  last_brace=$(grep -n '^}' "$MENU" | tail -1 | cut -d: -f1)
  sed -i "$((last_brace - 1))r menu.jsonc" "$MENU"
else
  mkdir -p "$(dirname "$MENU")"
  { echo "{"; cat menu.jsonc; echo "}"; } >"$MENU"
fi

omarchy-hook-install post-update hooks/screensaver-fx-check

echo "Installed. Current effects: $("$HOME/.local/bin/screensaver-fx" show)"
echo "Change it from Style > Screensaver > Effect, or: screensaver-fx set <effect>"
