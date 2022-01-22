#!/bin/bash

# begin of variables
var_service_name="plexmediaserver"
var_service_friendly_name="Plex Media Server"
var_service_friendly_name_length="================="
var_service_default_port="32400"
var_local_ip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
var_local_subnet=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}' | sed 's@[^.]*$@0/24@')
# end of variables

clear
echo "====================$var_service_friendly_name_length==========="
echo "== Arch Linux LXC - $var_service_friendly_name Updater =="
echo "====================$var_service_friendly_name_length==========="
echo
echo "This script will update $var_service_friendly_name."
echo
read -p "Press ENTER to start the script."
echo
echo
echo
echo

echo "Updating $var_service_friendly_name..."
echo "=========$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo "Stopping $var_service_friendly_name..."
sudo systemctl stop $var_service_name
echo
echo "Updating $var_service_friendly_name..."
git clone https://aur.archlinux.org/plex-media-server.git
cd plex-media-server
makepkg -sirc --noconfirm
cd
sudo rm -r plex-media-server
echo
echo
echo
echo

echo "Restarting $var_service_friendly_name..."
echo "===========$var_service_friendly_name_length==="
echo "The $var_service_friendly_name update is complete."
echo "Proceed to start $var_service_friendly_name and display the service status."
echo
read -p "Press ENTER to continue..."
echo
sudo systemctl start $var_service_name
echo "Waiting 5 seconds for $var_service_friendly_name to start..."
sleep 5
echo
sudo systemctl status $var_service_name
