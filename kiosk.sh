#!/bin/bash

echo -e "\n---------------------\n" "Epiphany-browser Kiosk mode Pi" "\n---------------------\n"
read -p "Which url do you whant to run in kiosk mode on raspberry GUI startup (ex: http://localhost...)?:" url


#
### Check / install deps
#

echo -e "\n-----\n" "Install or update necessary deps..." "\n-----\n"

sudo apt-get update
sudo apt-get dist-upgrade

sudo apt-get install epiphany-browser x11-xserver-utils xautomation unclutter


#
#### Create kiosk script file
#

echo -e "\n-----\n" "Create kiosk script file at /home/pi/fullscreen.sh" "\n-----\n"

#file data
fullscreenScript="sudo -u pi epiphany-browser -a -i --profile ~/.config $url --display=:0 &\n"'sleep 15s\n''xte "key F11" -x:0'

#Cleanup the file
if [ -e /home/pi/fullscreen.sh ]
then
	rm /home/pi/fullscreen.sh
fi
touch /home/pi/fullscreen.sh
sudo chmod 755 /home/pi/fullscreen.sh

#save file data
echo -e $fullscreenScript >> /home/pi/fullscreen.sh
echo -e "\nDONE.\n"


#
### Save & Create new autostart
#

echo -e "\n-----\n" "Save & Edit the autostart file to run fullscreen.sh" "\n-----\n"

#file data
autostartContent='@xset s off\n''@xset -dpms\n''@/home/pi/fullscreen.sh'

#Save original autostart if it's not already done
if [ -e /home/pi/.config/lxsession/LXDE-pi/autostart_origin ]
then
	echo 'INFO - The autostart file was already saved'
else
	cp /home/pi/.config/lxsession/LXDE-pi/autostart /home/pi/.config/lxsession/LXDE-pi/autostart_origin
fi

#Cleanup the file
if [ -e /home/pi/.config/lxsession/LXDE-pi/autostart ]
then
	rm /home/pi/.config/lxsession/LXDE-pi/autostart
fi
touch /home/pi/.config/lxsession/LXDE-pi/autostart

#Save file data
echo -e $autostartContent >> /home/pi/.config/lxsession/LXDE-pi/autostart
echo -e "\nDONE. You should restart your pi with 'sudo reboot' and enjoy the kiosk mode !"
