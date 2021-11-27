#!/bin/bash

clear
echo "================================================"
echo "== Arch Linux LXC Plex Media Server Installer =="
echo "================================================"
echo
echo "This script will install Plex Media Server."
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

echo "Installing Plex Media Server..."
echo "==============================="
read -p "Press ENTER to continue..."
echo
git clone https://aur.archlinux.org/plex-media-server.git
cd plex-media-server
makepkg -sirc --noconfirm
cd
sudo rm -r plex-media-server
echo
echo
echo
echo

echo "Configuring Plex Media Server..."
echo "================================"
read -p "Press ENTER to continue..."
echo

echo "Enabling and starting Plex Media Server..."
echo "=========================================="
echo "The installation and configuration of Plex Media Server is complete."
echo "Proceed to start Plex Media Server and display the service status."
echo
read -p "Press ENTER to continue..."
echo
sudo systemctl enable --now plexmediaserver
echo "Waiting 5 seconds for Plex Media Server to start..."
sleep 5
echo
sudo systemctl status plexmediaserver
