#!/usr/bin/env zsh
TARGET_DIR="$HOME/Pictures/wallpaper/"
WALLPAPER_PATH=$(zenity --file-selection --filename="$TARGET_DIR/")

sh "$HOME/.config/hypr/scripts/set_wallpaper.sh" "$WALLPAPER_PATH"

sh "$HOME/.config/hypr/scripts/generate_colors.sh"


