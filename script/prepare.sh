#!/bin/bash

### prepare a Raspberry Pi for kiosk mode and install the script for updates

if [ $EUID -ne 0 ]; then
    echo "$0 is not running as root. Try using sudo."
    exit 2
fi


apt install joe mc # for my convenience
apt install git # we need git

cd /home/pi
rm -rf JHM # get rid of previous installation
# ?? git clone URL
mkdir -p JHM
cd JHM

# ruby & gems
apt install ruby # we need ruby
gem install down # we need the down gem
gem install httparty # we need the httparty gem

# kiosk.sh
chown pi.pi kiosk.sh
chmod u=rwx,g=r,o= kiosk.sh

# add 'exec kiosk.sh' to .bashrc if needed
if grep -q "source ./kiosk.sh" /home/pi/.bashrc
then
    echo "already done .bashrc" # nothing to do
else
    echo "
source ./kiosk.sh
    " >> /home/pi/.bashrc
fi

# add mountpath for external drive to /etc/fstab if needed
if grep -q '^/dev/sda1 /var/www ntfs defaults 0 1' /etc/fstab
then
    echo "already done fstab" # nothing to do
else
    echo '
/dev/sda1 /var/www ntfs defaults 0 1
    ' >> /etc/fstab
fi
