#!/usr/bin/env python

import re, subprocess, os
from google_trans_new import google_translator

translatorNew = google_translator(url_suffix='us')

languages = {'Detect Language' : 'auto' , 'Afrikaans': 'af', 'Albanian': 'sq', 'Amharic': 'am', 'Arabic': 'ar', 'Armenian': 'hy',
             'Azerbaijani': 'az', 'Basque': 'eu', 'Belarusian': 'be', 'Bengali': 'bn', 'Bosnian': "bs",
             "Bulgarian": 'bg', "Catalan": "ca", "Cebuano": 'ceb', 'Chinese (Simplified)': 'zh-CN',
             'Chinese (Traditional)': 'zh-TW', 'Corsican': 'co', 'Croatian': 'hr', 'Czech': 'cs', 'Danish': 'da' ,
             "Dutch": 'nl', 'English': 'en', 'Esperanto': 'eo', 'Estonian': 'et', 'Finnish': 'fi', 'French': 'fr',
             'Frisian': 'fy', 'Galician': 'gl' , 'Georgian' : 'ka' , 'German' : 'de' , 'Greek': 'el' , 'Gujarati': 'gu' ,
             'Haitian Creole' : 'ht' , 'Hausa' : 'ha' , 'Hawaiian': 'haw', 'Hebrew': 'he', 'Hindi': 'hi', 'Hmong': 'hmn' ,
             'Hungarian' : 'hu', 'Icelandic' : 'is', 'Igbo' : 'ig', 'Indonesian' : 'id', 'Irish': 'ga', 'Italian': 'it',
             'Japanese': 'ja', 'Javanese': 'jv', 'Kannada': 'kn', 'Kazakh': 'kk', 'Khmer': 'km', 'Kinyarwanda': 'rw',
             'Korean': 'ko', 'Kurdish': 'ku', 'Kyrgyz': 'ky', 'Lao': 'lo', 'Latin': 'la', 'Latvian': 'lv',
             'Lithuanian': 'lt', 'Luxembourgish': 'lb', 'Macedonian': 'mk', 'Malagasy': 'mg', 'Malay': 'ms',
             'Malayalam': 'ml', 'Maltese': 'mt', 'Maori': 'mi', 'Marathi': 'mr', 'Mongolian': 'mn',
             'Myanmar (Burmese)': 'my', 'Nepali': 'ne', 'Norwegian': 'no', 'Nyanja (Chichewa)': 'ny',
             'Odia (Oriya) or Pashto' : 'ps', 'Persian': 'fa', 'Polish': 'pl', 'Portuguese (Portugal, Brazil)' : 'pt',
             'Punjabi': 'pa', 'Romanian': 'ro', 'Russian': 'ru', 'Samoan': 'sm', 'Scots Gaelic' : 'gd', 'Serbian' : 'sr' ,
             'Sesotho' : 'st' , 'Shona' : 'sn' , 'Sindhi' : 'sd' , 'Sinhala (Sinhalese)' : 'si', 'Slovak': 'sk',
             'Slovenian': 'sl', 'Somali': 'so', 'Spanish': 'es', 'Sundanese': 'su', 'Swahili': 'sw', 'Swedish': 'sv',
             'Tagalog (Filipino)' : 'tl' , 'Tajik': 'tg', 'Tamil': 'ta', 'Tatar': 'tt', 'Telugu': 'te', 'Thai':  'th',
             'Turkish': 'tr', 'Turkmen': 'tk', 'Ukrainian': 'uk', 'Urdu': 'ur', 'Uyghur': 'ug', 'Uzbek': 'uz',
             'Vietnamese': 'vi', 'Welsh': 'cy', 'Xhosa': 'xh', 'Yiddish': 'yi', 'Yoruba': 'yo', 'Zulu': 'zu'}


def clear_response(response):
    return str(re.findall(r"b\'([\w\W]+)\\n", str(response))[0])


def get_language():
    to_lang = languages.copy()
    del to_lang['Detect Language']
    languages_joined = '\n'.join(to_lang.keys())
    language_raw = subprocess.check_output(f"echo -e '{languages_joined}' | dmenu -p 'Translate to:' | xargs -I % echo '%'", shell=True)
    return languages[clear_response(language_raw)]


def get_from_language():
    languages_joined = '\n'.join(languages.keys())
    language_raw = subprocess.check_output(f"echo -e '{languages_joined}' | dmenu -p 'Translate from:' | xargs -I % echo '%'", shell=True)
    return languages[clear_response(language_raw)]


def get_words():
    word_raw = subprocess.check_output("echo -e | dmenu -p 'Word to translate' | xargs -I % echo '%'", shell=True)
    return clear_response(word_raw)


def translate():
    text = translatorNew.translate(get_words(), lang_src=get_from_language(), lang_tgt=get_language())
    answer = subprocess.check_output(f"echo -e 'Copy to clipboard\nAnother Word\nClose'| dmenu -p '{text}'", shell=True)
    if 'Copy' in str(answer):
        os.system(f"echo -n '{text}' | xclip -selection clipboard")
    elif 'Another' in str(answer):
        translate()
    else:
        pass


translate()

