#!/usr/bin/env bash

MAN_DIR="/usr/share/man/man1/"
PDF_VISUALIZER="/bin/sioyek"
CACHE_DIR="$HOME/.cache/sioyek"

if [ ! -d "$CACHE_DIR" ]; then
  mkdir -p "$CACHE_DIR"
fi

SELECTION=$(ls "$MAN_DIR" | sed 's/\.gz//g' | dmenu -l 15)

if [ -z "$SELECTION" ]; then
  dmenu -i -p "No manpage selected"
fi

RESULT=$(ls "$CACHE_DIR" | grep -c "$SELECTION\.pdf")

if [ "$RESULT" == "0" ]; then
  man -Tpdf "$SELECTION" > "$CACHE_DIR/$SELECTION.pdf"
fi
  $PDF_VISUALIZER "$CACHE_DIR/$SELECTION.pdf"
