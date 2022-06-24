# First recursively remove all orphans.
sudo pacman -Rns $(pacman -Qdqt)

# Remove old packages, keeping only the latest n versions of each installed package.
sudo paccache -rk1

# Remove all packages for uninstalled programs.
sudo paccache -ruk0

sudo rm -R ~/.cache/yay/

DIR=$HOME/Documents/Software/dotfiles/packages
touch $DIR

# Export the list of of explicit and all installed packages.
pacman -Qi  | awk '/^Name/{name=$3} /^Installed Size/{print $4$5, name}' | sort -hr> $DIR/all/by_size/${HOSTNAME}.txt
pacman -Qei | awk '/^Name/{name=$3} /^Installed Size/{print $4$5, name}' | sort -hr> $DIR/explicit/by_size/${HOSTNAME}.txt

pacman -Qi \
    | sed '/^URL/d' \
    | sed '/^Install Date/d' \
    | sed '/^Build Date/d' \
    | sed '/^Licenses/d' \
    | sed '/^Packager/d' \
    | sed '/^Install Script/d' \
    | sed '/^Validated By/d' \
    | sed '/^Installed Size/d' \
    | sed '/^Architecture/d' \
    | sed '/: None$/d' \
    > $DIR/all/verbose/${HOSTNAME}.txt

pacman -Qei \
    | sed '/^URL/d' \
    | sed '/^Install Date/d' \
    | sed '/^Build Date/d' \
    | sed '/^Licenses/d' \
    | sed '/^Packager/d' \
    | sed '/^Install Script/d' \
    | sed '/^Validated By/d' \
    | sed '/^Installed Size/d' \
    | sed '/^Architecture/d' \
    | sed '/: None$/d' \
    > $DIR/explicit/verbose/${HOSTNAME}.txt

pacman -Qq  > $DIR/all/by_name/${HOSTNAME}.txt
pacman -Qqe > $DIR/explicit/by_name/${HOSTNAME}.txt

# In the future, would like to make the package lists date stamped.  Why?

# Now partition installed packages based on the toolkit they require.
declare -a arr=(base qt5-base qt6-base gtk2 gtk3 python python2 perl js78 php ruby nodejs ncurses tcl java-runtime java-environment dotnet-runtime)

for PACKAGE in ${arr[@]}
do
    if [ ! -d $DIR/dependencies/$PACKAGE ]
    then
        mkdir $DIR/dependencies/$PACKAGE
        mkdir $DIR/dependencies/$PACKAGE/all
        mkdir $DIR/dependencies/$PACKAGE/explicit
    else 
        touch $DIR/dependencies/$PACKAGE
    fi

    # Adding -o includes packages that optionally depend on $PACKAGE.  Not sure I want this...
    pactree -ru $PACKAGE | sort > $DIR/dependencies/$PACKAGE/all/${HOSTNAME}.txt

    grep -f $DIR/dependencies/$PACKAGE/all/${HOSTNAME}.txt -x $DIR/explicit/by_name/${HOSTNAME}.txt > $DIR/dependencies/$PACKAGE/explicit/${HOSTNAME}.txt
done

# Now partition installed packages based on the group they're a part of.
declare -a arr=(base-devel gnome gnome-extra i3 kde-applications lxde lxqt plasma texlive-most vim-plugins x-apps xfce4 xfce4-goodies xorg xorg-apps)

for GROUP in ${arr[@]}
do
    if [ ! -d $DIR/groups/$GROUP ]
    then 
        mkdir $DIR/groups/$GROUP
    else 
        touch $DIR/groups/$GROUP
    fi
    # No need to join on explicit packages, as this only lists explicit installations.
    pacman -Qgq $GROUP | sort > $DIR/groups/$GROUP/${HOSTNAME}.txt
done

# Find manually installed python packages (pip). > pipes normal output, 2> pipes error output.
#pacman -Qo /usr/lib/python*/site-packages/* > /dev/null 2> $DIR/notManagedByPacman/python-pip/${HOSTNAME}.txt
#sed -i 's/error: No package owns //' $DIR/notManagedByPacman/python-pip/${HOSTNAME}.txt
pip list --user > $DIR/notManagedByPacman/python-pip/${HOSTNAME}.txt
pip list --local >> $DIR/notManagedByPacman/python-pip/${HOSTNAME}.txt

# Find manually installed R packages.
Rscript ~/Development/Scripts/findLocalRPackages.R > $DIR/notManagedByPacman/r/${HOSTNAME}.txt

# Find manually installed ruby gems.
gem list > $DIR/notManagedByPacman/ruby-gems/${HOSTNAME}.txt

# Find manually installed node packages.
npm list > $DIR/notManagedByPacman/nodejs/${HOSTNAME}.txt
npm list -g >> $DIR/notManagedByPacman/nodejs/${HOSTNAME}.txt

# Vim Packages
cd ~/.vim/bundle/
PLUGINS=(*)
echo "package,dateUpdated" > $DIR/notManagedByPacman/vim/${HOSTNAME}.csv
for PLUGIN in ${PLUGINS[@]}
do
    cd $PLUGIN
    echo $PLUGIN,$(git log -n 1 --format=%cd --date=short) >> $DIR/notManagedByPacman/vim/${HOSTNAME}.csv
    cd ..
done

# List running services.
DIR=$HOME/Documents/Software/dotfiles/services
touch $DIR
systemctl --type=service --state=running > $DIR/${HOSTNAME}.txt
systemctl --type=service --state=running --user > $DIR/${HOSTNAME}-user.txt
