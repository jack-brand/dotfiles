#!/usr/bin/env sh
set -eu

CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

WALLPAPER_DIR="$HOME/pictures/wallpapers"
swaybg -i "$WALLPAPER_DIR/isle_of_the_dead.png" &

WAYBAR_DIR="$CONF_DIR/waybar"
waybar -c "$WAYBAR_DIR/config.jsonc" -s "$WAYBAR_DIR/style.css" &

#noctalia &

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

