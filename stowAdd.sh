# determine where the file lives (and strip out $HOME)
FILE_NAME=$1
FULL_NAME=$(readlink -f $FILE_NAME)
FULL_PATH=$(dirname $FULL_NAME)
#RELATIVE_PATH=$(pwd $FILE_NAME)
COMMON_PATH=$(echo $FULL_PATH | sed 's/\/home\/brent//')

# set the package this file will belong to
PACKAGE=$2
if [ "$PACKAGE"  =  "" ]; then
    echo "Package name is required!"
    exit 1
fi

# set the directory structure of source and destination
SRC=$HOME/${COMMON_PATH} # should really be $PWD, but just to be safe
DEST=$HOME/dotfiles/${PACKAGE}/${COMMON_PATH}

SRC_FILE=$SRC/$FILE_NAME
DEST_FILE=$DEST/$FILE_NAME

#  copy the file in the dotfile repo 
mkdir --parents "${DEST}"
cp -i -v "$SRC_FILE" "${DEST}"

# compare 
meld "$SRC_FILE" "$DEST_FILE"
gvimdiff "$SRC_FILE" "$DEST_FILE"

# confirm changes
echo "Was the copy successful?  I.e., should the SOURCE_FILE be removed? (1) yes or (2) no"
read ANSWER

if [ $ANSWER == 1 ]
then
    rm "$SRC_FILE"
    echo "Removed $SRC_FILE".
else
    exit 1
fi
