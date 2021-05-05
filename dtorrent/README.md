#dTorrent
___
##Description:
Simple torrent manager for transmission-daemon. It reduces the time for your most common task.
You can still seeing your files in your browser (http://localhost:9091/transmission/web/)
Use transmission-daemon and xclip.

###Features:
Autoload transmission-daemon before any command, means, you don't need to load if before.
You can Add, Prioritize, Start, Stop, Remove your torrents or Kill the daemon 
After select any action it gives you the possibility of make another action.
##Usage:
- Add: add a torrent from the given url, it takes .torrent or magnetic link.
- Priority: the selected torrent will be high priority.
###tips:
####adding a torrent:
Copy the url (.torrent or magnetic links), then execute dTorrent, select the Add option, select clip from the clipboard, and your torrent is added.

####Recommended workflow for multiples torrents:
Copy the link of the torrent (to your clipboard), access to dmenu and open dtorrent, go to add -> paste from clipboard. Without pressing any other key, copy another other torrent link (with your mouse), and then press continue (in your dmenu), add -> paste from clipboard. Without
With this workflow you can surf in you prefered torrent website and going downloading everything without calling the app everytime, because you are coping with your mouse and pasting with your keyboard.



######I suggest:
1. rename the file to your preference, customized.
2. make it executable, so you can run it from dmenu.
3. move it to your $PATH, so you can access from everywhere.

