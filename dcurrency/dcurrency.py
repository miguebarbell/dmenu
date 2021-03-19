#!/usr/bin/env python

from currency_converter import CurrencyConverter
from bs4 import BeautifulSoup
import requests, re, subprocess

c = CurrencyConverter()
currencies = ['CLP', 'AUD', 'BGN', 'BRL', 'CAD', 'CHF', 'CNY', 'CYP', 'CZK', 'DKK', 'EEK', 'EUR', 'GBP', 'HKD', 'HRK', 'HUF', 'IDR', 'ILS', 'INR', 'ISK', 'JPY', 'KRW',
              'LTL', 'LVL', 'MTL', 'MXN', 'MYR', 'NOK', 'NZD', 'PHP', 'PLN', 'ROL', 'RON', 'RUB', 'SEK', 'SGD', 'SIT', 'SKK', 'THB', 'TRL', 'TRY', 'USD', 'ZAR']


def clp_usd(q):
    url = f"https://www.google.com/search?q={q}+clp+to+usd"
    html = requests.get(url)
    soup = BeautifulSoup(html.content, 'html.parser')
    precio = soup.find_all('div', class_='BNeawe iBp4i AP7Wnd')
    pattern = r'(\d+\.\d+)'
    clp = re.findall(pattern, str(precio))
    return clp[0]


def dmenu():
    callCurrency = "echo -e '" + str('\n'.join(currencies)) + "' | dmenu -p 'Select the currency:' | xargs -I % echo '%'"
    currencyDmenu = subprocess.check_output(callCurrency, shell=True)
    arg = re.findall(r"b\'(.*?)\\n\'", str(currencyDmenu))[0].upper()
    callQuantity = "echo -e | dmenu -p 'How many " + arg + "s:' | xargs -I % echo '%'"
    quantityDmenu = subprocess.check_output(callQuantity, shell=True)
    arg1 = re.findall(r"b\'(.*?)\\n\'", str(quantityDmenu))[0]
    if arg == 'CLP':
        answer = clp_usd(arg1)
    else:
        answer = round((c.convert(arg1, arg, 'USD')), 2)
    lastAnswer = f"echo -e 'Yes\nNo'| dmenu -p '{arg1} {arg}s are {answer} USDs, do you need another convertion?'"
    lastAnswer2 = subprocess.check_output(lastAnswer, shell=True)
    argLastAnswer2 = re.findall(r"b\'(.*?)\\n\'", str(lastAnswer2))[0]
    if argLastAnswer2 == 'Yes':
        dmenu()


dmenu()
