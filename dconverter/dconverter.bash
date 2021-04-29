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
}

temperature () {
  degrees=$1
  type=$2
  echo -e $degrees $type
#  TODO: make a convertion celsius t farenheit and reverse
}

distance () {
# TODO: distance converter
}

weight () {
  # TODO: weight function
}

main