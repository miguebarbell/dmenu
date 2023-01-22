#!/usr/bin/env bash
# make a script that allows see from eztv
# similar to tgx, so it can be integrated
#
BASE_URL="https://eztv.re/search/"

QUERY=$1
if [ -z "$1" ]; then
	QUERY=$(dmenu -p "Search for?")
fi
QUERY=$(echo "$QUERY" | sed 's/ /-/g')
DATA=$(curl -s $BASE_URL$QUERY)
TITLES="/tmp/titles"
echo "$DATA" | rg "magnet:\?" | sed 's/.*title="\(.*\) Magnet Link".*/\1/g' > "$TITLES"
SEEDERS="/tmp/seeders"
echo "$DATA" | rg "forum_thread_post_end" | sed -e 's/<font color="green">//' | sed 's/.*post_end">\(\w*\|\-\)<.*/\1/' > "$SEEDERS"

TITLE=$(paste -d" " "$SEEDERS" "$TITLES" | sort --sort=human-numeric -r | dmenu -i -p "Select the torrent" | cut -d' ' -f 1 --complement)
if [ "$TITLE" == "" ];then
	exit 0
fi

MAGNET=$(echo "$DATA" | rg -e "magnet:\?" | rg -F "$TITLE" | sed 's/.*href="\(.*\)" class="magnet".*/\1/')
WHAT=$(printf "Stream\nDownload" | dmenu -i -p "$TITLE")
if [ "$WHAT" == "" ];then
	exit 0
fi

if [ "$WHAT" == "Stream" ]; then
	echo "Streaming $TITLE"
	peerflix "$MAGNET" --vlc
	# peerflix "$MAGNET" -k -q -r
else
	echo "Downloading $TITLE"
	transmission-daemon && sleep 3
	transmission-remote -a "$MAGNET"
fi
