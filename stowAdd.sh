FILE_PATH=$1
FILE_PATTERN=$2
PACKAGE=$3

DOTFILES="${HOME}/dotfiles"
SRC=$HOME/${FILE_PATH}
DEST=${DOTFILES}/${PACKAGE}/${FILE_PATH}

mkdir --parents ${DEST}
cp -i -v ${SRC}/${FILE_PATTERN} ${DEST}