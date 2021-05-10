#!/bin/bash
main() {
  text=$(echo -e | dmenu -p 'TTS: ')
  file="audio`date +'%F-%T'`"
#  echo "$text" > audiotts | text2wave -eval '(voice_cmu_us_awb_cg)' audiotts | lame - "$file.mp3"
  echo "$text" > audiotts | text2wave audiotts | lame - "$file.mp3"
  rm audiotts
  mv $file.mp3 ~/
  echo | dmenu -p "Saved as ~/$file.mp3"
}


main
