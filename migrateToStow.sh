FILE_PATH=$1
FILE_PATTERN=$2
PACKAGE=$3

DOTFILES="${HOME}/dotfiles"
SRC=${DOTFILES}/${FILE_PATH}
DEST=${DOTFILES}/${PACKAGE}/${FILE_PATH}

mkdir --parents ${DEST}
cd $DOTFILES
git mv -n -v ${SRC}/${FILE_PATTERN} {DEST}

echo "Everything look good? (1) Yes (2) No."
read ANSWER
if [ $ANSWER == "1" ]
then
    # actually perform the move
    git mv ${SRC}/${FILE_PATTERN} ${DEST}
else
    exit 1
fi