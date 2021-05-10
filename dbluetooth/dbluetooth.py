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
    return adresses[index], connect2.decode()


def allAbove(tupleAdressName):
    os.system('bluetoothctl power on')
    result = subprocess.run(['bluetoothctl', 'connect', str(tupleAdressName[0])], capture_output=True)
    if result.returncode == 0:
        os.system(f"echo | dmenu -p 'Connected to {tupleAdressName[1]}'")
    else:
        os.system(f"echo | dmenu -p 'Failed to connect {tupleAdressName[1]}'")
        print(f"Failed to connect to {tupleAdressName[1]} check if your device is in pairing mode and the computer have any phisical button for power on the bluetooth")


allAbove(getAdressFromArg())