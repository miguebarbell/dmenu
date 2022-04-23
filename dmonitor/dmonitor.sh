#!/usr/bin/sh
# main device
#MAIN=eDP1
#ALL_MONITORS=$(cat list)
ALL_MONITORS=$(xrandr)
function set_monitors() {
	MAIN=$(printf "$ALL_MONITORS" | grep " connected" | sed -n 1p | cut -d' ' -f 1)
	OPTIONS=$(printf "$ALL_MONITORS" | grep " connected" | cut -d' ' -f 1 | sed 1d)
	if [[ $OPTIONS == "" ]]; then
		echo "no monitors";
		echo -e "" | dmenu -p "no external monitors found!"
		exit 1;
	fi
	EXTERNAL=$(echo $OPTIONS | dmenu -p "Which monitor?")
	WHERE=$(echo -e "left-of\nright-of\nabove\nbelow" | dmenu -p "place $EXTERNAL in relation of $MAIN")
	LINE_START=$(printf "$ALL_MONITORS" | grep -n $EXTERNAL | cut -d':' -f 1)
	LINE_START=$(expr $LINE_START + 1)
	LINE_LAST=$(printf "$ALL_MONITORS" | sed -n "`echo $LINE_START`,$"p | grep -n connected | cut -d':' -f 1)
	LINE_LAST=$(expr $LINE_LAST + $LINE_START - 1)
	RESOLUTION=$(printf "$ALL_MONITORS" | sed -n "`echo $LINE_START`,`echo $LINE_LAST`"p | grep -o "[0-9]\+x[0-9]\+[a-z]*" | dmenu -l 20 -p "Select the output resolution for $EXTERNAL")
	#RESOLUTION=$(echo -e "2K @ 2650x1440\n4K @ 3840x2160\nFHD @ 1920x1090\nHD @ 1280x720\nAnother resolution" | dmenu -l 5 -p "Select the output resolution for $EXTERNAL" )
	if [[ $RESOLUTION == "Another resolution" ]]; then
		RESOLUTION=$(echo -e "" | dmenu -p "Which resolution? iex: 680x550");
		elif [[ $RESOLUTION == "2K"* ]]; then RESOLUTION="2650x1440"
		elif [[ $RESOLUTION == "4K"* ]]; then RESOLUTION="3840x2160"
		elif [[ $RESOLUTION == "FHD"* ]]; then RESOLUTION="1920x1090"
		elif [[ $RESOLUTION == "HD"* ]]; then RESOLUTION="1280x720"
	fi
	CONFIRM=$(echo -e "yes\nno" | dmenu -p "setting $EXTERNAL ($RESOLUTION) $WHERE $MAIN")
	if [[ $CONFIRM == "yes" ]]; then
		xrandr --output $EXTERNAL --mode $RESOLUTION --$WHERE $MAIN && echo -e "" | dmenu -p "$EXTERNAL @ $RESOLUTION $WHERE $MAIN" && AGAIN="exit" || AGAIN=$(echo -e "exit\ntry it again" | dmenu -p "something wrong, Whats next?")
		else
			AGAIN=$(echo -e "exit\ntry it again" | dmenu -p "Whats next?")
	fi
}
while [[ $AGAIN != "exit" ]]; do set_monitors; done
if [[ $AGAIN == "exit" ]]; then exit 0; fi
