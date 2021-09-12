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

echo "Installing required packages..."
echo "==============================="
read -p "Press ENTER to start..."
echo
pacman -Syyu git base-devel --noconfirm
echo
echo
echo
echo

echo "Building Jellyfin from Git repository..."
echo "========================================"
echo "https://aur.archlinux.org/jellyfin.git"
echo
read -p "Press ENTER to start..."
echo
mkdir git
cd git
git clone https://aur.archlinux.org/jellyfin.git
cd jellyfin
makepkg -sirc
echo
echo
echo
echo
