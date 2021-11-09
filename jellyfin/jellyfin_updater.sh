#!/bin/bash

clear
echo "====================================="
echo "== Arch Linux LXC Jellyfin Updater =="
echo "====================================="
echo
echo "This script will update Jellyfin."
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

echo "Updating Jellyfin..."
echo "===================="
read -p "Press ENTER to continue..."
echo
echo "Stopping Jellyfin.."
sudo systemctl stop jellyfin
echo
echo "Updating Jellyfin.."
git clone https://aur.archlinux.org/jellyfin-bin.git
cd jellyfin-bin
makepkg -sirc --noconfirm
cd
sudo rm -r jellyfin-bin
echo
echo
echo
echo

echo "Restarting Jellyfin..."
echo "======================"
echo "The Jellyfin update is complete."
echo "Proceed to start Jellyfin and display the service status."
echo
read -p "Press ENTER to continue..."
echo
sudo systemctl start jellyfin
echo "Waiting 5 seconds for Jellyfin to start..."
sleep 5
echo
sudo systemctl status jellyfin
