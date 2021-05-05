#!/bin/bash
main() {
  text=$(echo -e | dmenu -p 'TTS: ')
  file="audio`date +'%F-%T'`"
#  echo "$text" > audiotts | text2wave -eval '(voice_cmu_us_kal_diphone)' audiotts | lame - "$file.mp3"
  echo "$text" > audiotts | text2wave audiotts | lame - "$file.mp3"
  mv $file.mp3 ~/
  echo | dmenu -p "Saved as ~/$file.mp3"
}

clean () {
  rm audiotts
}

main
clean