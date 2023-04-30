import unicodedata
import re
import sys

def remove_illegal_chars(filename):
    """
    Remove any illegal characters from the given filename string.
    """
    # Define a regular expression that matches any illegal character
    illegal_chars_regex = r'[\\/:\*\?"<>\|]'

    # Remove any matches of the illegal character regex from the filename string
    return re.sub(illegal_chars_regex, '', filename)

string = sys.argv[1]

if re.search(r'[^\x00-\x7F]', string):
    name = ''.join(c if ord(c) < 128 else unicodedata.normalize('NFKD', c).encode('ASCII', 'ignore').decode() for c in string)
else:
    name = string

clean_name = remove_illegal_chars(name)

print(clean_name)
