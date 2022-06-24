# Script to swap (DM) services.
oldService=$1
newService=$2

sudo systemctl disable $oldService
sudo systemctl enable $newService