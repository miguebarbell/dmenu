pid=$(ps -u $USER -o pid,%mem,%cpu,comm | sort -b -k2 -r | sed -n '1!p' | dmenu -l 10 | awk '{print $1}')
kill -15 $pid 2>/dev/null
