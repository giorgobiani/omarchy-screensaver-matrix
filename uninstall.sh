#!/bin/bash
# Remove screensaver-fx and restore Omarchy's random screensaver effects.

set -euo pipefail

MENU="$HOME/.config/omarchy/extensions/omarchy-menu.jsonc"

sudo rm -f /usr/local/bin/ttfx
rm -f "$HOME/.local/bin/screensaver-fx" "$HOME/.local/bin/matrix-rain" \
  "$HOME/.config/omarchy/screensaver-fx.conf" \
  "$HOME/.config/omarchy/hooks/post-update.d/screensaver-fx-check"
[[ -f $MENU ]] && sed -i '/\/\/ >>> screensaver-fx/,/\/\/ <<< screensaver-fx/d' "$MENU"

echo "Uninstalled. The screensaver is back to random effects."
