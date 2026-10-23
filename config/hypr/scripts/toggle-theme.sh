#!/usr/bin/env zsh

# Файл для збереження поточного стану теми
STATE_FILE="$HOME/.cache/current_theme"

# Визначаємо поточний стан (за замовчуванням dark)
if [[ -f "$STATE_FILE" ]]; then
  CURRENT_THEME=$(cat "$STATE_FILE")
else
  CURRENT_THEME="dark"
fi

if [[ "$CURRENT_THEME" == "dark" ]]; then
  # === ПЕРЕМКНЕННЯ НА LIGHT ===
  TARGET_THEME="light"
  COLOR_SCHEME="prefer-light"
  GTK_THEME_NAME="Adwaita"
  QT_STYLE="fusion"
  FF_DARK_INT=0

  echo "Перемикання на СВІТЛУ тему..."
else
  # === ПЕРЕМКНЕННЯ НА DARK ===
  TARGET_THEME="dark"
  COLOR_SCHEME="prefer-dark"
  GTK_THEME_NAME="Adwaita-dark"
  QT_STYLE="kvantum-dark"
  FF_DARK_INT=1

  echo "Перемикання на ТЕМНУ тему..."
fi

# 1. GTK / xdg-desktop-portal (gsettings)
gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME_NAME"

# 2. GTK3 & GTK4 settings.ini
for gtk_ver in gtk-3.0 gtk-4.0; do
  GTK_INI="$HOME/.config/$gtk_ver/settings.ini"
  if [[ -f "$GTK_INI" ]]; then
    if [[ "$TARGET_THEME" == "dark" ]]; then
      sed -i 's/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=1/' "$GTK_INI"
    else
      sed -i 's/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=0/' "$GTK_INI"
    fi
    sed -i "s/gtk-theme-name=.*/gtk-theme-name=$GTK_THEME_NAME/" "$GTK_INI"
  fi
done

# 3. Qt5 / Qt6 (qt5ct / qt6ct)
for conf in "$HOME/.config/qt5ct/qt5ct.conf" "$HOME/.config/qt6ct/qt6ct.conf"; do
  if [[ -f "$conf" ]]; then
    sed -i "s/style=.*/style=$QT_STYLE/" "$conf"
  fi
done

# 4. Flatpak global overrides
if command -v flatpak &>/dev/null; then
  flatpak override --user --env=COLOR_SCHEME="$COLOR_SCHEME"
  flatpak override --user --env=GTK_THEME="$GTK_THEME_NAME"
fi

# 5. Firefox / Zen Browser profiles
setopt NULL_GLOB 2>/dev/null
for pref_file in $HOME/.mozilla/firefox/*default*/prefs.js $HOME/.zen/*default*/prefs.js; do
  if [[ -f "$pref_file" ]]; then
    if grep -q "ui.systemUsesDarkTheme" "$pref_file"; then
      sed -i "s/user_pref(\"ui.systemUsesDarkTheme\", .*);/user_pref(\"ui.systemUsesDarkTheme\", $FF_DARK_INT);/" "$pref_file"
    else
      echo "user_pref(\"ui.systemUsesDarkTheme\", $FF_DARK_INT);" >>"$pref_file"
    fi
  fi
done

# Записуємо новий стан
echo "$TARGET_THEME" >"$STATE_FILE"

# Сповіщення
if command -v notify-send &>/dev/null; then
  notify-send "Тему змінено" "Встановлено режим: $TARGET_THEME" -i preferences-desktop-theme
fi
