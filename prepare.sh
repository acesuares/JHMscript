#!/bin/bash
if [ $EUID -ne 0 ]; then
    echo "$0 is not running as root. Try using sudo."
    exit 2
fi

apt install joe mc # for my convenience

# ruby & gems
apt install ruby # we need ruby
gem install down # we need the down gem
gem install httparty # we need the httparty gem

# kiosk.sh
chown pi.pi kiosk.sh
chmod u=rwx,g=r,o= kiosk.sh

# add 'exec kiosk.sh' to .bashrc if needed
if grep -q "source ./kiosk.sh" .bashrc
then
    echo "already done" # nothing to do
else
    echo "
source ./kiosk.sh
    " >> .bashrc
fi
