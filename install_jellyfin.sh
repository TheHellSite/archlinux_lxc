#!/bin/bash

clear
echo "=========================================="
echo "== Arch Linux LXC Jellyfin installation =="
echo "=========================================="
echo
echo "This script will install Jellyfin."
echo
read -p "Press ENTER to start the script."
echo
echo
echo

echo "Preparing AUR..."
echo "================"
read -p "Press ENTER to start..."
echo
sudo pacman -Syyu git base-devel --noconfirm
echo
echo
echo

echo "Installing Jellyfin..."
echo "======================"
read -p "Press ENTER to start..."
echo
mkdir git && cd git && git clone https://aur.archlinux.org/jellyfin-bin.git && cd jellyfin-bin && makepkg -sirc && cd && sudo rm -r git
sudo systemctl enable --now jellyfin && sudo systemctl status jellyfin && sudo systemctl stop jellyfin
echo
echo
echo

echo "Configuring Jellyfin..."
echo "======================="
read -p "Press ENTER to start..."
echo
#mkdir git && cd git && git clone https://aur.archlinux.org/jellyfin-bin.git && cd jellyfin-bin && makepkg -sirc && cd && sudo rm -r git
#sudo systemctl enable --now jellyfin && sudo systemctl status jellyfin && sudo systemctl stop jellyfin
echo
echo
echo
