#!/usr/bin/env zsh
IMAGE_PATH=$(sed -n 's/.*\(\/home\/[^\%]*\.png\).*/\1/p' "$HOME/.cache/awww/0.12.1/DP-1")
CURRENT_THEME=$(<"$HOME/.cache/current_theme")

if [[ "$CURRENT_THEME" == light ]]; then
  CONTRAST=0.5
else
  CONTRAST=0
fi

matugen image "$IMAGE_PATH" --source-color-index 0 -m "$CURRENT_THEME" --contrast "$CONTRAST"
