#!/usr/bin/env zsh
WALLPAPER_DIR="$HOME/Pictures/wallpaper/"

bg=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.gif" \) | shuf -n 1)
awww img "$bg"
