#!/bin/bash

# TODO: expand to the others torrent servers

URL1337X='https://www.1377x.to'
QUERY="$(echo | dmenu -p 'Search for:' | sed s'/ /%20/g')"
#echo $QUERY
CAT=$(echo -e 'Movies\nTV\nGames\nMusic\nApps\nDocumentaries\nAnime\nOther\nEverything\nCancel' | dmenu -p 'Category:')
#echo $CAT
#CAT=$(echo -e 'Movies\nTV\nGames\nMusic\nApps\nDocumentaries\nAnime\nOther\nXXX\nEverything' | dmenu -p 'Category:')

# This is an early cancel
if [[ "$CAT" == "Cancel" ]]; then exit 0; fi

function search_1337x() {
  # will search in 1337x server
  if [[ $2 == 'Everything' ]]; then
			#echo "$URL1337X/search/$1/1"
      RESULTS=$(curl -s $URL1337X/search/$1/1/ | pup 'tbody tr td.coll-1 a:nth-of-type(2)' json{})
			#echo $RESULTS
    else
			#echo "$URL1337X/category-search/$1/$2/1"
      #RESULTS=$(curl -s $URL1337X/category-search/$1/$2/1/ | pup 'td.coll-1 a:nth-of-type(2)' json{})
			RESULTS=$(curl -s $URL1337X/category-search/$1/$2/1/ | pup 'tbody tr td.coll-1 a:nth-of-type(2)' json{})
			#echo $RESULTS
  fi
	echo $RESULTS
	if [[ "$RESULTS" == [] ]]; then
		echo "No Results for $QUERY" | dmenu
		exit 0
	fi
  TITLE_SELECTED=$(echo $RESULTS | jq '.[].text' | dmenu -p 'Results:' -l 10)
	if [[ "$TITLE_SELECTED" == "" ]]; then exit 0; fi
  LINK_SELECTED=$(echo $RESULTS | jq "map(select(.text == $TITLE_SELECTED)) | .[].href" | sed s'/"//g')
  MAGNET_LINK=$(curl -s $URL1337X$LINK_SELECTED | grep 'magnet' | pup '[href]:last-child' json{} | jq '.[0].href' | sed s'/"//g')
  if [[ 'Documentaries' == $2  || 'Movies' == $2 || 'TV' == $2 ]]; then
    WHAT=$(echo -e "Download\nStream\nCancel" | dmenu -p "What?")

    if [[ $WHAT == "Stream" ]]; then
        echo -e | dmenu -p "Streaming $TITLE_SELECTED"
        peerflix $MAGNET_LINK -k -q -r
        exit 0
		elif [[ $WHAT == "Cancel" ]]; then exit 0
    fi
  fi
	transmission-daemon
  transmission-remote -a $MAGNET_LINK
  # echo -e | dmenu -p "Downloading $TITLE_SELECTED"
	notify-send "🔽 Torrent added." "$TITLE_SELECTED"
  exit 0
}

search_1337x "$QUERY" "$CAT"
