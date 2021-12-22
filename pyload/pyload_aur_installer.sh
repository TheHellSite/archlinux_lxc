#!/bin/bash

clear
echo "======================================="
echo "== Arch Linux LXC pyLoad Installer =="
echo "======================================="
echo
echo "This script will install pyLoad."
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

echo "Installing pyLoad..."
echo "======================"
read -p "Press ENTER to continue..."
echo
git clone https://aur.archlinux.org/pyload-ng.git
cd pyload-ng
makepkg -sirc --noconfirm
cd
sudo rm -r pyload-ng
echo
echo
echo
echo
