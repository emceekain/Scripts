TARGET_DIR=$HOME
SOURCE_DIR=$HOME/dotfiles

PACKAGES=(
    alacritty
    beets
    conky
    doublecmd
    dunst
    i3
    jupyter
    kdiff3
    krusader
    lyx
    misc
    nitrogen
    picom
    plasma
    ranger
    shells
    spyder
    sqlitebrowser
    systemd
    taskwarrior
    texstudio
    urxvt
    vim
    vscode
    webApps
    xfceApps
    youtube-dl
    zathura
)

echo "Specify the package you'd like to deploy (defaults to ALL)."
read PACKAGE
if [ "$PACKAGE" != "ALL" ] && [ "$PACKAGE" != "" ]; then 
    PACKAGES=( ${PACKAGE} )
    echo "Single package mode."
else
    echo "All package mode."
fi

echo "Performing dry run."
echo ""

for package in ${PACKAGES[@]}
do
    echo "Installing ${package}."
    stow -n -t ${TARGET_DIR} -d ${SOURCE_DIR} ${package}
    echo ""
done

echo "Proceed with deployment? (1) yes or (2) no"
read ANSWER

if [ $ANSWER == 1 ]
then
    for package in ${PACKAGES[@]}
    do
        echo "Installing ${package}."
        stow -v -t ${TARGET_DIR} -d ${SOURCE_DIR} ${package}
        echo ""
    done
else
    exit 1
fi
