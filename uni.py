import unicodedata
import re
import sys
string = sys.argv[1]

if re.search(r'[^\x00-\x7F]', string):
    name = ''.join(c if ord(c) < 128 else unicodedata.normalize('NFKD', c).encode('ASCII', 'ignore').decode() for c in string)
else:
    name = string

print(name)
