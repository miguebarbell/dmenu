# dmenu
##Utilities for dmenu
Collections of utilities for dmenu.
dmenu was created for simplicity in your workflow, so you can save time in usual tasks.
These programs I created because helps with my common goals, fast and easy. My dmenu color is orange xD, so can differ from yours.


>1. dtorrent:
>> Simple manager for transmission-daemon. Wrote in bash.
![dtorrent](dtorrent/dtorrent.gif)
  
>2. dtranlator:
>>  Translate a word, have the capability of detect the input language, you select the output (of course) . Use google database.
![dtranslator](dtranslator/dtranslator.gif)

>3. dcurrency:
>> Convert from 43 most common currencies to USD. CLP included using webscraping.
![dcurrency](dcurrency/dcurrency.gif)

>4. dbluetooth:
>> Connect to your bluetooth trusted connection, when bluetoothctl doesn't connect automatically, this do the job.
![dbluetooth](dbluetooth/dbluetooth.gif)

>5. dmonitor:
>> Use xrandr for connect to an external display. So if you ussually jump from monitor to TV or projector, this is for you.
![dmonitor](dmonitor/dmonitor.gif)

>6. dconverter:
>> Simple unit converter, metric <-> imperial.
![dconverter](dconverter/dconverter.gif)

>7. dtts:
>> Create a mp3 from text (Text To Speech). Use festival. This is useful in message apps where you want some privacy with an anonymous voice or just prank a friend. 
![dtts](dtts/tts2.gif)


##Usage:
Well the most important file is the .py or .bash
The goal is make it executable (chmod +x) and moving it to your path, like ~/.local/bin /bin
This way you can access from dmenu. **Its good idea to try and use it before moving it to the path.**
###Official method:
1. git clone
2. go to the folder of the app you want to use, in example `dmenu/dtorrent` 

###Shady way:
1. Go to the file, inspect and copy the content.
2. create a file, `$ touch dtorrent` and copy all the content inside of it.
3. make it executable and move it to your path.

1. You Should copy the script that you want (and if you want rename) to you local/bin path and make it executable (chmod +x FILE). 
So you can access from dmenu to the script.
2. sometimes make a file executable means that you trust on the developer, before do that, I strongly request to you see the code so you can be sure it doesn't do any malign in your machine. I'll try to put more explanatory comments in the code.
