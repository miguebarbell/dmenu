#!/bin/bash

main () {
  what=$(echo -e 'Temperature\nDistance\nWeight' | dmenu -p 'Convert: ')
  quantity=$(echo -e '' | dmenu -p 'Quantity: ')
  if [[ $what == 'Temperature' ]]; then
    unit=$(echo -e 'Celsius\nFahrenheit' | dmenu -p '')
    temperature $quantity $unit
  elif [[ $what == 'Distance' ]]; then
    unit=$(echo -e 'Mts\nFeets' | dmenu -p '')
    distance $quantity $unit
  elif [[ $what == 'Weight' ]]; then
    unit=$(echo -e 'Kilos\nPounds' | dmenu -p '')
    weight $quantity $unit
    fi
  last
}

temperature () {
#  echo -e $degrees $type
  if [[ $2 == 'Celsius' ]]; then
    echo -e | dmenu -p "`printf '%.*f\n' 2 $(($1 * 9/5 + 32))` °F"
  else
    echo -e | dmenu -p "`printf '%.*f\n' 2 $((($1 - 32)/1.8))` °C"
    fi
}

distance () {
  if [[ $2 == 'Mts' ]]; then
    echo -e | dmenu -p "`printf '%.*f\n' 2 $(($1 / 0.3048))` Feets"
  else
    echo -e | dmenu -p "`printf '%.*f\n' 2 $(($1 * 0.3048))` Meters"
    fi
}

weight () {
  if [[ $2 == 'Kilos' ]]; then
    echo -e | dmenu -p "`printf '%.*f\n' 2 $(($1 * 2.20462262185))` Pounds"
  else
    echo -e | dmenu -p "`printf '%.*f\n' 2 $(($1 / 2.20462262185))` Kilos"
    fi
}

last () {
  last=$(echo -e 'Yes\nNo' | dmenu -p 'Another convertion?')
  if [[ $last == 'Yes' ]]; then
    main
  fi
}

main