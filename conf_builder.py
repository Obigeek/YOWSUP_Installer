#!/usr/bin/env python
# This is a simple Python function that will open a text file and perform a find/replace, and save to a new text file.
import sys

def replace_words(base_text, device_values):
    for key, val in device_values.items():
        base_text = base_text.replace(key, val)
    return base_text

# Here I'll create an empty dictionary, and prompt the user to enter in the values

device = {}

device[" _VERSION = "] = " _VERSION = '" + sys.argv[1] + "' # Old Version - "
device["_MD5_CLASSES = "] = "_MD5_CLASSES = '" + sys.argv[2] + "' # Old MD5 Hash - "

# Open your desired file as 't' and read the lines into string 'tempstr'

t = open('env_android.py', 'r')
tempstr = t.read()
t.close()


# Using the "replace_words" function, we'll pass in our tempstr to be used as the base,
# and our device_values to be used as replacement.

output = replace_words(tempstr, device)

# Write out the new config file

fout = open('env_android_new.py', 'w')
fout.write(output)
fout.close()
