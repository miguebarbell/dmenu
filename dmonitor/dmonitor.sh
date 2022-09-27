#!/usr/bin/sh
#ALL_MONITORS=$(cat list)
ALL_MONITORS=$(xrandr)
set_monitors() {
	MAIN=$(printf %s "$ALL_MONITORS" | grep " connected" | sed -n 1p | cut -d' ' -f 1)
	OPTIONS=$(printf %s "$ALL_MONITORS" | grep " connected" | cut -d' ' -f 1 | sed 1d)
	if [ -z "$OPTIONS" ]; then
		echo "no monitors";
		printf "" | dmenu -p "ERROR: no external monitors found!" -sb "#FF0700" -sf "#000000" -fn 'Verdana-18';
		exit 1;
	fi
	EXTERNAL=$(printf %s "$OPTIONS" | dmenu -p "Which output?")
	while [ -z "$EXTERNAL" ]; do
		EXTERNAL=$(printf exit\\n%s "$OPTIONS" | dmenu -p "You didn't select any output, what to exit?" -sb "#FFD700" -sf "#000000")
		if [ "$EXTERNAL" = "exit" ]; then exit 0; fi
		done

	WHERE=$(printf "left-of\nright-of\nabove\nbelow" | dmenu -p "place $EXTERNAL in relation of $MAIN")
	while [ -z "$WHERE" ]; do
	WHERE=$(printf "exit\nleft-of\nright-of\nabove\nbelow" | dmenu -p "place $EXTERNAL in relation of $MAIN")
	if [ "$WHERE" = "exit" ]; then exit 0; fi
	done
	LINE_START=$(printf %s "$ALL_MONITORS" | grep -n "$EXTERNAL" | cut -d':' -f 1)
	LINE_START=$(($(printf %s "$LINE_START") + 1))
	LINE_LAST=$(printf %s "$ALL_MONITORS" | sed -n "$(printf %s $LINE_START),\$"p | grep -n connected | cut -d':' -f 1)
	LINE_LAST=$(($(printf %s "$LINE_LAST") + $(printf %s "$LINE_START") - 1))
	RESOLUTION=$(printf %s "$ALL_MONITORS" | sed -n "$(printf %s $LINE_START),$(printf %s $LINE_LAST)"p | grep -o "[0-9]\+x[0-9]\+[a-z]*" | sed -e '$a Another resolution' | dmenu -l $((LINE_LAST - LINE_START + 1)) -p "Select the output resolution for $EXTERNAL")
	while [ -z "$RESOLUTION" ]; do
	RESOLUTION=$(printf %s "$ALL_MONITORS" | sed -n "$(printf %s $LINE_START),$(printf %s $LINE_LAST)"p | grep -o "[0-9]\+x[0-9]\+[a-z]*" | sed -e '$a Another resolution' -e "1iexit" | dmenu -l $((LINE_LAST - LINE_START + 2)) -p "Select the output resolution for $EXTERNAL")
		if [ "$RESOLUTION" = "exit" ]; then exit 0; fi
		done
	case $RESOLUTION in
	  "Another resolution")
		RESOLUTION=$(printf "" | dmenu -p "Which resolution? iex: 680x550")
		;;
		"2K"*)
		RESOLUTION="2650x1440"
		;;
		"4K"*)
		RESOLUTION="3840x2160"
		;;
		"FHD"*)
		RESOLUTION="1920x1090"
		;;
		"HD"*)
		RESOLUTION="1280x720"
		;;
		*)
		AGAIN="exit"
	esac
	#CONFIRM=$(printf "yes\nno" | dmenu -p "setting $EXTERNAL ($RESOLUTION) $WHERE $MAIN")
	#if [ "$CONFIRM" = "yes" ]; then
		xrandr --output "$EXTERNAL" --mode "$RESOLUTION" --"$WHERE" "$MAIN" && AGAIN=$(printf "exit\ntry it again" | dmenu -p "was as expected?") && AGAIN="exit" || AGAIN=$(printf "exit\ntry it again" | dmenu -p "something wrong, Whats next?" -sb "#FFD700" -sf "#000000")
		#else
			#AGAIN=$(printf "exit\ntry it again" | dmenu -p "Whats next?")
	#fi
}
while [ "$AGAIN" != "exit" ]; do set_monitors; done
if [ "$AGAIN" = "exit" ]; then exit 0; fi
