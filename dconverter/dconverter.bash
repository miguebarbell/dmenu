#!/bin/bash

main () {
# TODO: make a workflow to solve a selected non existence option
  what=$(echo -e 'Temperature\nDistance\nWeight' | dmenu -p 'Convert: ')
  quantity=$(echo -e '' | dmenu -p 'Quantity: ')
  if [[ $what == 'Temperature' ]]; then
    unit=$(echo -e 'Celsius\nFahrenheit' | dmenu -p '')
    temperature "$quantity" "$unit"
  elif [[ $what == 'Distance' ]]; then
    unit=$(echo -e 'Mts\nFeets' | dmenu -p '')
    distance "$quantity" "$unit"
  elif [[ $what == 'Weight' ]]; then
    unit=$(echo -e 'Kilos\nPounds' | dmenu -p '')
    weight "$quantity" "$unit"
    fi
  last
}

temperature () {
#  echo -e $degrees $type
  if [[ $2 == 'Celsius' ]]; then
    echo -e | dmenu -p "`printf '%.*f\n' 2 $(($1 * 9/5 + 32))` °F"
  else
		celsius=$(awk "BEGIN {print ($1 - 32)/1.8}")
    echo -e | dmenu -p "`printf %.2f $celsius` C"
    fi
}

distance () {
  if [[ $2 == 'Mts' ]]; then
		feet=$(awk "BEGIN {print $1 / 0.3048}")
    echo -e | dmenu -p "`printf %.2f $feet` Feet"
  else
		meters=$(awk "BEGIN {print $1 * 0.3048}")
    echo -e | dmenu -p "`printf %.2f $meters` Meters"
    fi
}

weight () {
  if [[ $2 == 'Kilos' ]]; then

		kilos=$(awk "BEGIN {print $1 * 2.20462262185}")
    echo -e | dmenu -p "`printf %.2f $kilos` Pounds"
  else
		pounds=$(awk "BEGIN {print $1 / 2.20462262185}")
    echo -e | dmenu -p "`printf %.2f $pounds` Kilos"
    fi
}

last () {
  last=$(echo -e 'Yes\nNo' | dmenu -p 'Another conversion?')
  if [[ $last == 'Yes' ]]; then
    main
  fi
}

terminal() {
# returns the automatic conversion but in the inverse unit
# 100 k returns 45.06 pounds
# TODO: refactor, so both main function can use the same small functions
	unit=${2^^}
	case "$unit" in
		K|KILO*)
		pounds=$(awk "BEGIN {print $1 / 2.20462262185}")
		echo "$pounds Pounds";;
		LB*|P|POUND*)
		kilos=$(awk "BEGIN {print $1 * 2.20462262185}")
		echo "$kilos Kilos";;
		FE*|FT*)
		meters=$(awk "BEGIN {print $1 * 0.3048}")
		echo "$meters Meters";;
		M|METER*)
		feet=$(awk "BEGIN {print $1 / 0.3048}")
		echo "$feet FEET";;
		F|FAR*)
		celsius=$(awk "BEGIN {print ($1 - 32)/1.8}")
		echo "$celsius Celsius";;
		C|CEL*)
		fahrenheit=$(awk "BEGIN {print ($1 * 9/5) + 32}")
		echo "$fahrenheit Fahrenheit"
	esac
}


if [[ $1 == "" ]]; then
	main
	else
	terminal "$1" "$2"
	fi
