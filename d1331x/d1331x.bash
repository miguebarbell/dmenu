#!/bin/bash

URL1337X='https://www.1377x.to'
QUERY=$(echo |
dmenu -p 'Search for: ')
CAT=$(echo -e 'Movies\nTV\nGames\nMusic\nApps\nDocumentaries\nAnime\nOther\nEverything' | dmenu -p 'Category:')
#CAT=$(echo -e 'Movies\nTV\nGames\nMusic\nApps\nDocumentaries\nAnime\nOther\nXXX\nEverything' | dmenu -p 'Category:')

function search_1337x() {
  # will search in 1337x server
  if [[ $2 == 'Everything' ]]; then
      RESULTS=$(curl -s $URL1337X/search/$1/1 | pup 'tbody tr td.coll-1 a:nth-of-type(2)' json{})
    else
      RESULTS=$(curl -s $URL1337X/category-search/$1/$2/1 | pup 'tbody tr td.coll-1 a:nth-of-type(2)' json{})
  fi
  TITLE_SELECTED=$(echo $RESULTS | jq '.[].text' | dmenu -p 'Results:' -l 10)
  LINK_SELECTED=$(echo $RESULTS | jq "map(select(.text == $TITLE_SELECTED)) | .[].href" | sed s'/"//g')
  MAGNET_LINK=$(curl -s $URL1337X$LINK_SELECTED | grep 'magnet' | pup '[href]:last-child' json{} | jq '.[0].href' | sed s'/"//g')
  if [[ 'Documentaries' == $2  || 'Movies' == $2 ]]; then
    WHAT=$(echo -e "Stream\nDownload" | dmenu -p "What?")
    if [[ $WHAT == "Stream" ]]; then
        echo -e | dmenu -p "Streaming $TITLE_SELECTED"
        peerflix $MAGNET_LINK -k -q -r
        exit 0
    fi
  fi
  echo -e | dmenu -p "Downloading $TITLE_SELECTED"
  transmission-remote -a $MAGNET_LINK
  exit 0
}

search_1337x $QUERY $CAT
