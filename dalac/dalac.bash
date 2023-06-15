#!/usr/bin/env bash

THEME_FOLDER=$XDG_CONFIG_HOME/alacritty/alacritty-theme/themes/
WAL_THEME=$XDG_CACHE_HOME/wal/colors.alacritty.yml
ALACRITTY_CONF=$XDG_CONFIG_HOME/alacritty/alacritty.yml

THEME=$(printf "DARK\nLIGHT\n%s" "$(ls "$THEME_FOLDER")" | rofi -dmenu -p "Select Alacrity Theme")

if [ "$THEME" = "DARK" ]; then
	wal -i "$(cat "$XDG_CACHE_HOME"/wal/wal)"
	THEME=$WAL_THEME
elif [ "$THEME" = "LIGHT" ]; then
	wal -l -i "$(cat "$XDG_CACHE_HOME"/wal/wal)"
	THEME=$WAL_THEME
else
	THEME="$THEME_FOLDER""$THEME"
fi

line=$(grep -n "# from alac" "$XDG_CONFIG_HOME"/alacritty/alacritty.yml | cut -d':' -f 1)
line=$(("$line" + 1))
sed -i "$line s,.*,  - $THEME," "$ALACRITTY_CONF"

