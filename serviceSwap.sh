# Script to swap (DM) services.
#oldService=$1
oldService=$(systemctl status display-manager.service | grep --only-matching --max-count=1 "\w*.service" | sed 's/.service//')
newService=$1

sudo systemctl disable "$oldService"
sudo systemctl enable "$newService"