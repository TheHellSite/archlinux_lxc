#!/bin/bash

clear
echo "=========================================="
echo "== Arch Linux LXC Jellyfin installation =="
echo "=========================================="
echo
echo "This script will install Jellyfin inside"
echo "an Arch Linux LXC."
echo
read -p "Press ENTER to start the script."
echo
echo
echo

echo "Building Jellyfin from Git repository..."
echo "========================================"
echo "https://aur.archlinux.org/jellyfin-bin.git"
echo
read -p "Press ENTER to start..."
echo
mkdir git
cd git
git clone https://aur.archlinux.org/jellyfin-bin.git
cd jellyfin
makepkg -sirc
echo
echo
echo
echo
