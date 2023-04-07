#!/usr/bin/env bash
# TODO: merge with EZTV and x1313

dmenu_p() {
  dmenu -sb '#00FFFF' -sf '#000000' -nf '#00FFFF' -nb '#000000' -shf '#FF00FF' -shb '#00FFFF' -nhb '#000000' -nhf '#FF00FF' -i -p "$@"
}

URLTGX='https://torrentgalaxy.to'
QUERY="$(echo | dmenu -p 'Search for' -sb '#00FFFF' -sf '#000000' -nf '#00FFFF' | sed s'/ /%20/g')"
# CAT=$(echo -e 'Movies\nTV\nTraining\nGames\nMusic\nApps\nDocumentaries\nAnime\nOther\nEverything\nCancel' | dmenu -p 'Category:')
CAT=$(echo -e 'Movies\nTV\nTraining\nGames\nMusic\nApps\nDocumentaries\nAnime\nOther\nEverything\nCancel' | dmenu_p 'Category')
function search_tgx() {
  if [[ "$2" == 'Everything' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ "$2" == 'Movies' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c3=1&c45=1&c42=1&c4=1&c1=1&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ "$2" == 'TV' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c41=1&c5=1&c11=1&c6=1&c7=1&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ "$2" == 'Games' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c20=1&c21=1&c18=1&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ "$2" == 'Music' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c26=1&c23=1&c25=1&c24=1&c17=1&c40=1&c=37=1&c=33&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ "$2" == 'Documentaries' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c9=1&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ "$2" == 'Other' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c26=1&c23=1&c25=1&c24=1&c17=1&c40=1&c=37=1&c=33&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ "$2" == 'Anime' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c28=1&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  elif [[ "$2" == 'Training' ]]; then
    PAGE_RESULTS=$(curl -s "$URLTGX/torrents.php?c33=1&search=$QUERY&lang=0&nox=2&sort=seeders&order=desc")
  fi
  DATA=$(echo "$PAGE_RESULTS" | rg "id='click'")
  TITLES="/tmp/titles"
  SEEDERS="/tmp/seeders"
  echo "$DATA" | sed 's/.*title="\(.*\)" href.*/\1/g' >"$TITLES"
  echo "$DATA" | sed 's/.*<font color='\''green'\''><b>\(\w*,\?\w\+\)<\/b><\/font.*/\1/g' >"$SEEDERS"
  TITLE=$(paste -d" " "$SEEDERS" "$TITLES" | sort --sort=human-numeric -r | dmenu -i -p "Select the torrent" | cut -d' ' -f 1 --complement)
  if [[ "$TITLE" == "" ]]; then
    exit 0
  fi
  MAGNET=$(echo "$DATA" | rg -F "$TITLE" | sed 's/.*href="\(magnet:?.*\)" role=.*/\1/g')
  echo "$MAGNET"
  if [[ "$CAT" == "Movies" || "$CAT" == "TV" ]]; then
    WHAT=$(printf "Stream\nDownload" | dmenu -i -p "$TITLE")
    if [[ "$WHAT" == "" ]]; then
      exit 0
    fi

    if [[ "$WHAT" == "Stream" ]]; then
      echo "Streaming $TITLE"
      peerflix "$MAGNET" --vlc
    fi
    # peerflix "$MAGNET" -k -q -r
  else
    echo "Downloading $TITLE"
    transmission-daemon && sleep 3 && transmission-remote -a "$MAGNET"
  fi
}

search_tgx "$QUERY" "$CAT"
