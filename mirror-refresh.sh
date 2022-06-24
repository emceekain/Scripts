# Back up the current version of the mirrorlist (just in case).
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

# Download the latest mirrorlist from the Arch Linux website (US-only).
#wget 'https://www.archlinux.org/mirrorlist/?country=US&protocol=https' -O ~/Downloads/mirrorlist_new

# Uncomment every server in the new file.
#sed -i 's/^#Server/Server/' ~/Downloads/mirrorlist_new

# Keep only the fastest 6 mirrors in the new file.
#rankmirrors -n 6 ~/Downloads/mirrorlist_new > ~/Downloads/mirrorlist_$HOSTNAME

# Replace the old mirror list with the new one.
#sudo cp ~/Downloads/mirrorlist_$HOSTNAME /etc/pacman.d/mirrorlist

# Remove the extra file(s).
#rm ~/Downloads/mirrorlist_new


# Nah, just use Reflector
sudo reflector --verbose --latest 5 --country US --protocol https --sort rate --save /etc/pacman.d/mirrorlist