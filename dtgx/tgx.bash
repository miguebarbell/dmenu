#!/bin/bash

URLTGX='https://torrentgalaxy.to'
QUERY="$(echo | dmenu -p 'Search for:' | sed s'/ /%20/g')"
CAT=$(echo -e 'Movies\nTV\nTraining\nGames\nMusic\nApps\nDocumentaries\nAnime\nOther\nEverything\nCancel' | dmenu -p 'Category:')
function search_tgx() {
  if [[ $2 == 'Everything' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ $2 == 'Movies' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c3=1&c45=1&c42=1&c4=1&c1=1&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ $2 == 'TV' ]];then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c41=1&c5=1&c11=1&c6=1&c7=1&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ $2 == 'Games' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c20=1&c21=1&c18=1&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ $2 == 'Music' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c26=1&c23=1&c25=1&c24=1&c17=1&c40=1&c=37=1&c=33&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ $2 == 'Documentaries' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c9=1&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ $2 == 'Other' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c26=1&c23=1&c25=1&c24=1&c17=1&c40=1&c=37=1&c=33&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ $2 == 'Anime' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c28=1&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ $2 == 'Training' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c33=1&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  fi
  RESULTS=$(echo $PAGE_RESULTS | pup 'div#click.tgxtablecell div a' json{} | jq 'map(select(.class == "txlight"))')
  TITLE_SELECTED=$(echo $RESULTS | jq '.[].title' | dmenu -p 'Results:' -l 10)
  if [[ $"$TITLE_SELECTED" == "" ]]; then exit 0; fi
  LINK_SELECTED=$(echo $RESULTS | jq "map(select(.title == $TITLE_SELECTED)) | .[].href" | sed s'/"//g')
  MAGNET_LINK=$(curl -s $URLTGX$LINK_SELECTED | pup 'center a.txlight.lift.btn.btn-danger' json{} | jq '.[2].href' | sed s'/"//g')
  if [[ 'Documentaries' == "$2"  || 'Movies' == "$2" || 'TV' == "$2" ]]; then
    WHAT=$(echo -e "Download\nStream\nCancel" | dmenu -p "What?")
    if [[ $WHAT == "Stream" ]]; then
        echo -e | dmenu -p "Streaming $TITLE_SELECTED"
        peerflix "$MAGNET_LINK" -k -q -r
        exit 0
		elif [[ $WHAT == "Cancel" || $WHAT == "" ]]; then exit 0
    fi
  fi
  echo -e | dmenu -p "Downloading $TITLE_SELECTED"

  addtorrent "$MAGNET_LINK"
  #transmission-remote -a $MAGNET_LINK
  exit 0
}

search_tgx "$QUERY" "$CAT"
