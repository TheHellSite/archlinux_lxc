#!/bin/bash

clear
echo "=============================================="
echo "== Arch Linux LXC Plex Media Server Updater =="
echo "=============================================="
echo
echo "This script will update Plex Media Server."
echo
read -p "Press ENTER to start the script."
echo
echo
echo
echo

echo "Preparing AUR..."
echo "================"
read -p "Press ENTER to continue..."
echo
sudo pacman -Syyu --noconfirm git base-devel
echo
echo
echo
echo

echo "Updating Plex Media Server..."
echo "===================="
read -p "Press ENTER to continue..."
echo
echo "Stopping Plex Media Server.."
sudo systemctl stop plexmediaserver
echo
echo "Updating Plex Media Server.."
git clone https://aur.archlinux.org/plex-media-server.git
cd plex-media-server
makepkg -sirc --noconfirm
cd
sudo rm -r plex-media-server
echo
echo
echo
echo

echo "Restarting Plex Media Server..."
echo "======================"
echo "The Plex Media Server update is complete."
echo "Proceed to start Plex Media Server and display the service status."
echo
read -p "Press ENTER to continue..."
echo
sudo systemctl start plexmediaserver
echo "Waiting 5 seconds for Plex Media Server to start..."
sleep 5
echo
sudo systemctl status plexmediaserver
