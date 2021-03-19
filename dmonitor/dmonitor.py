#!/usr/bin/env python
import subprocess, re, os

where, output, resolution, actual, what = 'right-of', 'HDMI-1', '1920x1080', 'eDP-1', 'same-as'


def getResolutions():
    monitorRaw = subprocess.check_output('xrandr', shell=True)
    monitorClear = re.findall(r"n(\w+(-\d{0,2}-\d{0,1})", str(monitorRaw))
    return monitorClear


def getMonitor():
    monitorRaw = subprocess.check_output('xrandr', shell=True)
    monitorClear = re.findall(r"n(\w+((-\d{0,2}){1}(-\d{0,1}){0,1}))", str(monitorRaw))
    return [monitorClear[i][0] for i in range(0, len(monitorClear))]


def dmenuWhere():
    global where, what
    arguments = "echo -e 'Extra\nDuplicate\nDisconnect' | dmenu -p 'Monitor SetUp:' | xargs -I % echo '%'"
    ansArguments = subprocess.check_output(arguments, shell=True)
    if 'Extra' in str(ansArguments):
        position = "echo -e 'left-of\nright-of\nabove\nbelow' | dmenu -p 'Where place the Duplicate Monitor?' | xargs -I % echo '%'"
        ansPosition = subprocess.check_output(position, shell=True)
        where = re.findall(r"b'(\w+-*\w+)\\n'", str(ansPosition))[0]
        what = 'Extra'
    elif 'Disconnect' in str(ansArguments):
        what = 'Disconnect'
    else:
        what = 'Duplicate'


def dmenuResolution():
    global resolution
    resolutionArgs = "echo -e '2K\n4K\nFHD\nHD\nAnother resolution' | dmenu -p 'Select the output resolution' | xargs -I % echo '%'"
    ansResolutionArgs = subprocess.check_output(resolutionArgs, shell=True)
    ansResolutionArgsClean = re.findall(r"b'(\w+\s*\w*)\\n", str(ansResolutionArgs))
    if 'Another resolution' in ansResolutionArgsClean:
        anotherResolutionArg = "echo -e | dmenu -p 'Which resolution? ex: 680x550' | xargs -I % echo '%'"
        anotherResolution = subprocess.check_output(anotherResolutionArg, shell=True)
        resolution = re.findall(r"b'(\d+x\d+)\\n'" , str(anotherResolution))[0]
    elif '2K' in ansResolutionArgsClean:
        resolution = '2560x1440'
    elif '4K' in ansResolutionArgsClean:
        resolution = '3840x2160'
    elif 'FHD' in ansResolutionArgsClean:
        resolution = '1920x1080'
    else:
        resolution = '1280x720'



def dmenuOutput():
    global output
    monitors = str('\n'.join(getMonitor()))
    arguments = subprocess.check_output(f"echo -e '{monitors}' | dmenu -p 'Which output?' | xargs -I % echo '%'", shell=True)
    output = str(re.findall(r"b'(\w+-\d+)\\n'", str(arguments))[0])


def allTogether():
    dmenuWhere()
    dmenuOutput()
    if what == 'Disconnect':
        os.system(f"xrandr --output {output} --off")
        os.system(f"echo -e | dmenu -p 'Shutting down {output}...'")
    else:
        dmenuResolution()
        if what == 'Extra':
            os.system(f'xrandr --output {output} --set audio force-dvi --mode {resolution} && xrandr --output {actual} --auto --output {output} --{where} {actual}')
            os.system(f"echo -e | dmenu -p 'Adding {output} at {resolution} {where} {actual}'")
        else:
            os.system(f"xrandr --output {output} --set audio force-dvi --mode {resolution} && xrandr --output {actual} --auto --output {output} --same-as {actual}")
            os.system(f"echo -e | dmenu -p 'Cloning {actual} to {output} at {resolution}'")


allTogether()
