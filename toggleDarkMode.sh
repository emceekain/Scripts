mode=$1
DOTFILES=$HOME/dotfiles
alacritty_config=${DOTFILES}/alacritty/.config/alacritty/alacritty.toml
light_alacritty_theme="import = \[\"~\/.config\/alacritty\/themes\/PencilLight.toml\"\]"
dark_alacritty_theme="import = \[\"~\/.config\/alacritty\/themes\/Molokai.toml\"\]"
vimrc=${DOTFILES}/vim/.vimrc
gtk3_settings=$HOME/.config/gtk-3.0/settings.ini
gtk4_settings=$HOME/.config/gtk-4.0/settings.ini
settingsFiles=("$gtk3_settings $gtk4_settings")

if [ $mode = "dark" ]
then 
    $HOME/.local/bin/jt -t monokai
    # vimrc
    sed -i -e "s/set background=light/set background=dark/" $vimrc

    # alacritty
    sed -i -e "s/^$light_alacritty_theme/# $light_alacritty_theme/" "$alacritty_config"
    sed -i -e "s/# $dark_alacritty_theme/$dark_alacritty_theme/" "$alacritty_config"

    # gtk
    for settings in "${settingsFiles[@]}"; do
        sed -i -e "s/gtk-application-prefer-dark-theme=false/gtk-application-prefer-dark-theme=true/" "$settings"
    done
    #sed -i -e "s/gtk-theme-name=.*/gtk-theme-name=Equilux-compact/" $gtk3_settings
    #sed -i -e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=Papirus-Dark/" $gtk3_settings

    echo "Dark theme enabled."
elif [ $mode = "light" ] || [ $mode = "mixed" ]
then 
    $HOME/.local/bin/jt -t grade3

    # vimrc
    sed -i -e "s/set background=dark/set background=light/" $vimrc

    # alacritty
    sed -i -e "s/^$dark_alacritty_theme/# $dark_alacritty_theme/" $alacritty_config
    sed -i -e "s/# $light_alacritty_theme/$light_alacritty_theme/" $alacritty_config

    # gtk
    for settings in "${settingsFiles[@]}"; do
        sed -i -e "s/gtk-application-prefer-dark-theme=true/gtk-application-prefer-dark-theme=false/" "$settings"
    done
    if [ $mode = "light" ]
    then 
        #sed -i -e "s/gtk-theme-name=.*/gtk-theme-name=Qogir-light/" $gtk3_settings
        #sed -i -e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=Papirus-Light/" $gtk3_settings
        echo "Light theme enabled."
    elif [ $mode = "mixed" ]
    then
        #sed -i -e "s/gtk-theme-name=.*/gtk-theme-name=Qogir/" $gtk3_settings
        #sed -i -e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=Papirus/" $gtk3_settings
        echo "Mixed theme enabled."
    fi
else 
    echo "No theme passed."
fi

$HOME/.config/polybar/scripts/color-switch.sh

# Change GTK theme.
lxappearance

# Change Plasma/QT color scheme.
systemsettings5 kcm_colors
qt5ct
kvantummanager
qt6ct

# replace these with respective changes to 
# $HOME/.config/gtk-3.0/settings.ini
# $HOME/.config/kdeglobals
# $HOME/.config/qt5ct/qt5ct.conf

# Change Vim, or should it read from environment variables?
meld $HOME/.lyx/preferences_dark $HOME/.lyx/preferences $HOME/.lyx/preferences_light

# URxvt
#nvim $HOME/.Xresources
#xrdb $HOME/.Xresources

# Refresh Polybar

# Restart background programs that need to be re-themed.
programs=(
    '/usr/lib/xfce4/notifyd/xfce4-notifyd'
    'syncthing-gtk'
    'synapse'
    'volumeicon'
    'nm-applet'
    'redshift-gtk'
    'blueman-tray'
    #'pamac-tray'
    #'xfce4-power-manager'
)
for program in "${programs[@]}"
do
    killall $program
    $program &
    echo "$program restarted."
done

i3 restart
#pkill 
