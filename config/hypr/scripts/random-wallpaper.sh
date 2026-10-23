#!/usr/bin/env zsh
WALLPAPER_DIR="$HOME/Pictures/wallpaper/"

bg=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.gif" \) | shuf -n 1)

sh "$HOME/.config/hypr/scripts/set_wallpaper.sh" "$bg"

sh "$HOME/.config/hypr/scripts/generate_colors.sh"
