PATH_TO_MIGRATE=$1
FILE_PATTERN=$2
PACKAGE=$3

DOTFILES="${HOME}/dotfiles"
cd ${DOTFILES}

mkdir --parents ${PACKAGE}/${PATH_TO_MIGRATE}
git mv -n -v ${PATH_TO_MIGRATE}/${FILE_PATTERN} ${PACKAGE}/${PATH_TO_MIGRATE}

echo "Everything look good? (1) Yes (2) No."
read ANSWER
if [ $ANSWER == "1" ]
then
    # actually perform the move
    git mv ${DOTFILES}/${PATH_TO_MIGRATE}/${FILE_PATTERN} ${DOTFILES}/${PACKAGE}/${PATH_TO_MIGRATE}
else
    exit 1
fi