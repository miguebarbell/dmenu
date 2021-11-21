#!/bin/bash

# This app works with transmission app and clipboard.
function main() {
# As a ensurance of the daemon is running, we call it first everything
  transmission-daemon

  function menu_after() {
# This is a function that is called everythime you do something, will ask if you need to continue doing another thing (like adding another torrent)
  option_after=$(echo -e 'Exit\nContinue' | dmenu -p 'Whats next?')
    if [[ $option_after == 'Continue' ]]; then
      main
    fi
  }

	function get_torrent_id() {

  	transmission-remote -l | awk '{ print $1 " " $(NF-1) " " $NF }' | awk 'NR>2 {print last} {last=$0}' | dmenu -l 5 -p 'Which torrent?' | awk '{ print $1 }'
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
	 id=$(get_torrent_id) 
	 echo transmission-remote -t $id -S
   transmission-remote -t $id -S
  elif [[ $option == 'Start' ]]; then
	 id=$(get_torrent_id) 
   transmission-remote -t $id -s
  elif [[ $option == 'Priority' ]]; then
	 id=$(get_torrent_id) 
   transmission-remote -t $id -ph all
  elif [[ $option == 'Start All' ]]; then
    transmission-remote -t all -s
  elif [[ $option == 'Stop All' ]]; then
    transmission-remote -t all -S
  else
	 id=$(get_torrent_id) 
   transmission-remote -t $id -r
  fi
  menu_after
}

main
