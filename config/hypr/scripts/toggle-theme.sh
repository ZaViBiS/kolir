#!/usr/bin/env bash
STATE_FILE="$HOME/.cache/current_theme"

current=$(cat "$STATE_FILE" 2>/dev/null)
[[ "$current" == "light" ]] && new="dark" || new="light"

if [[ "$new" == "dark" ]]; then
    gtk_theme="Adwaita-dark"
    kde_scheme="BreezeDark"
else
    gtk_theme="Adwaita"
    kde_scheme="BreezeLight"
fi

# GTK3 + GTK4/libadwaita
gsettings set org.gnome.desktop.interface color-scheme "prefer-$new"
gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"

# KDE
kwriteconfig6 --file kdeglobals --group General --key ColorScheme "$kde_scheme"

echo "$new" > "$STATE_FILE"

sh "$HOME/.config/hypr/scripts/generate_colors.sh"
