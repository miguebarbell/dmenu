#!/usr/bin/env python

import subprocess
import re
import os


def get_bluetooth():
    stat = "bluetooth --help | egrep -o 'on|off'"
    res = subprocess.check_output(stat, shell=True)
    btStat = True if 'on' in str(res) else False
    if btStat:
        return 'BT+'
    elif not btStat:
        return 'BT-'


def get_bluetooth_device():
    was = get_bluetooth()
    if was != 'BT+':
        return 'BT off'
    stat = "bluetoothctl paired-devices"
    res = subprocess.check_output(stat, shell=True)
    pattern = r'(Device\s\w\w:\w\w:\w\w:\w\w:\w\w:\w\w\s)([\w.\s]*)'
    devices = re.findall(pattern, str(res))
    clearedDevices = []
    for device in devices:
        clearedDevices.append(device[1])
    return clearedDevices


def getAdressFromArg():
    dmenu = "echo -e '" + str('\n'.join(get_bluetooth_device())) + "'| dmenu -p 'Connect to:' | xargs -I % echo '%'"
    connect2 = subprocess.check_output(dmenu, shell=True)
    arg = re.findall(r"b\'(.*?)\\n\'", str(connect2))[0]
    index = get_bluetooth_device().index(arg)
    stat = "bluetoothctl paired-devices"
    res = subprocess.check_output(stat, shell=True)
    pattern = r'(\w\w:\w\w:\w\w:\w\w:\w\w:\w\w)'
    adresses = re.findall(pattern, str(res))
    return adresses[index]


os.system('bluetoothctl power on')
command = 'bluetoothctl connect ' + str(getAdressFromArg())
os.system(command)
