#!/bin/bash

function main() {
  transmission-daemon

  function menu_after() {
  option_after=$(echo -e 'Exit\nContinue' | dmenu -p 'Whats next?')
    if [[ $option_after == 'Continue' ]]; then
      main
    fi
  }

  option=$(echo -e 'Add\nPriority\nStart\nStop\nStart All\nStop All\nRemove\nKill Daemon' | dmenu -p 'options:')
  if [[ $option == 'Add' ]]; then
    torrent=$(echo -e 'Paste from clipboard' | dmenu -p 'Add torrent from: ')
    if [[ $torrent == 'Paste from clipboard' ]]; then
      clipboard=$(xclip -out -selection clipboard)
      transmission-remote --add "$clipboard"
    fi
  elif [[ $option == 'Kill Daemon' ]]; then
    killall transmission-daemon
  elif [[ $option == 'Stop' ]]; then
   id=$(transmission-remote -l | awk '{ print $1 " " $(NF-1) " " $NF }' | awk 'NR>2 {print last} {last=$0}' | dmenu -l 5 -p 'Stop' | awk '{ print $1 }')
   transmission-remote -t $id -S
  elif [[ $option == 'Start' ]]; then
   id=$(transmission-remote -l | awk '{ print $1 " " $(NF-1) " " $NF }' | awk 'NR>2 {print last} {last=$0}' | dmenu -l 5 -p 'Start' | awk '{ print $1 }')
   transmission-remote -t $id -s
  elif [[ $option == 'Priority' ]]; then
   id=$(transmission-remote -l | awk '{ print $1 " " $(NF-1) " " $NF }' | awk 'NR>2 {print last} {last=$0}' | dmenu -l 5 -p 'Priority' | awk '{ print $1 }')
   transmission-remote -t $id -ph all
  elif [[ $option == 'Start All' ]]; then
    transmission-remote -t all -s
  elif [[ $option == 'Stop All' ]]; then
    transmission-remote -t all -S
  else
   id=$(transmission-remote -l | awk '{ print $1 " " $(NF-1) " " $NF }' | awk 'NR>2 {print last} {last=$0}' | dmenu -l 5 -p 'Remove' | awk '{ print $1 }')
   transmission-remote -t $id -r
  fi
  menu_after
}

main
