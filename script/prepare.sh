#!/bin/bash

### prepare a Raspberry Pi for kiosk mode and install the script for updates

BASEDIR='/home/pi/JHMscript'

# run as root
if [ $EUID -ne 0 ]; then
    echo "$0 is not running as root. Try using sudo."
    exit 2
fi

# needed packages
apt install -y joe mc # for my convenience
apt install -y git # we need git

# ruby & gems
apt install -y ruby # we need ruby
gem install down # we need the down gem
gem install httparty # we need the httparty gem

cd $BASEDIR/script

# kiosk.sh
chown pi.pi kiosk.sh
chmod u=rwx,g=r,o= kiosk.sh

# add 'exec kiosk.sh' to .bashrc if needed
if grep -q "source $BASEDIR/script/kiosk.sh" /home/pi/.bashrc
then
    echo "already done .bashrc" # nothing to do
else
    echo "
source $BASEDIR/script/kiosk.sh
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

# unmount and remount the external drive
umount /media/*
mount -a

# download for the first time

/usr/bin/ruby $BASEDIR/script/download.rb

# reboot
#reboot

### END
