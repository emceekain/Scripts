import shutil
import sys
import os
import re
from datetime import date

EXISTING_FILES = 0
NEW_FILES = 0

RELATIVE_PLAYLIST_PATH = sys.argv[1]
DEVICE = sys.argv[2]
MODE = sys.argv[3]
DATED = bool(sys.argv[4])
# file name is everything after the _last_ slash
RELATIVE_FILE_NAME = RELATIVE_PLAYLIST_PATH.split('/')[-1]
# extension is everything after the _last_ period
FILE_NAME_COMPONENTS = RELATIVE_FILE_NAME.split('.')
PLAYLIST_NAME = ".".join(FILE_NAME_COMPONENTS[:-1])
EXTENSION = FILE_NAME_COMPONENTS[-1]
if DATED:
    PLAYLIST_NAME += f"_{date.today()}"

deviceToPathConversion = {
    'primary': '/run/media/brent/Files/Syncthing/Shared Music/Primary/',
    'borrowed': '/run/media/brent/Files/Syncthing/Shared Music/Borrowed/',
    'my_music': '/run/media/brent/Files/Syncthing/Shared Music/My Music/',
    'oldies': '/run/media/brent/Files/Syncthing/Shared Music/Oldies/',
    'drumming': '/run/media/brent/Files/Syncthing/Shared Music/Drumming/',
    'nathan': "/run/media/brent/Files/Syncthing/Natronica's Music Swap/For Nathan/"
}

if DEVICE not in deviceToPathConversion.keys():
    print("You must specify primary, borrowed, oldies, or drumming.")
    sys.exit()
    # Need to stop the program here.

NEW_ROOT = deviceToPathConversion[DEVICE]
PLAYLIST_NAME_FULL = NEW_ROOT + PLAYLIST_NAME + '.' + EXTENSION

with open(PLAYLIST_NAME_FULL, 'w', encoding='utf-8') as NEW_PLAYLIST:

    with open(RELATIVE_PLAYLIST_PATH, 'r', encoding='utf-8') as ORIGINAL_PLAYLIST:
        lines = ORIGINAL_PLAYLIST.read().splitlines()

    for line in lines:
        if not line.startswith('#EXT') and len(line) > 3:
            OLD_PATH = line
            # print (line.strip('/run/media/brent/Files/Music/'))
            RELATIVE_PATH = re.sub(
                '/run/media/brent/Files/Music/[^/]+/', '', line)
            NEW_PATH = NEW_ROOT + RELATIVE_PATH
            if os.path.isfile(NEW_PATH):
                EXISTING_FILES += 1
            else:
                os.makedirs(os.path.dirname(NEW_PATH), exist_ok=True)
                shutil.copy2(OLD_PATH, NEW_PATH)
                NEW_FILES += 1
            NEW_PLAYLIST.write(RELATIVE_PATH + '\n')

print(f"{NEW_FILES} files copied and {EXISTING_FILES} already in place for a "
      + f"total of {NEW_FILES+EXISTING_FILES} in the playlist.")

print(f"{PLAYLIST_NAME}.m3u has been successfully copied.")
if MODE == 'utf8':
    # make a utf-8 compatible copy; may no longer be necessary for PowerAmp
    shutil.copy2(PLAYLIST_NAME_FULL, PLAYLIST_NAME_FULL + "8")
    print(f"{PLAYLIST_NAME}.m3u8 has been successfully copied as well.")

# for line in open(playlist,'r').read().splitlines():
#    if not line.startswith('#EXT') and len(line)>3:
#        OLD_PATH = line
#        list = OLD_PATH.split("/")[-3:]
#        NEW_PATH = NEW_ROOT + list[0] + "/" + list[1] + "/" + list[2]
#        os.makedirs(os.path.dirname(NEW_PATH),exist_ok=True)
#        shutil.copy2(OLD_PATH,NEW_PATH)
#        NEW_PLAYLIST.write(list[0] + "/" + list[1] + "/" + list[2] + '\n')
#    else:
#        NEW_PLAYLIST.write(line + '\n')
