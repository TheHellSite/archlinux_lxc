#!/bin/bash

# begin of variables
var_service_name="jellyfin"
var_service_friendly_name="Jellyfin"
var_service_friendly_name_length="========"
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
git clone https://aur.archlinux.org/jellyfin-bin.git
cd jellyfin-bin
makepkg -sirc --noconfirm
cd
sudo rm -r jellyfin-bin
#echo
#
# WAIT FOR JELLYFIN-FFMPEG5-BIN AUR release.
# https://aur.archlinux.org/packages/jellyfin-ffmpeg5#comment-892529
#
echo "Updating FFmpeg5 for Jellyfin ..."
git https://aur.archlinux.org/jellyfin-ffmpeg5-bin.git
cd jellyfin-ffmpeg5-bin
makepkg -sirc --noconfirm
cd
sudo rm -r jellyfin-ffmpeg5-bin
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
