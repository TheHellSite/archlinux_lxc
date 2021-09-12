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

echo " required packages..."
echo "==============================="
read -p "Press ENTER to start..."
echo
pacman -Syyu git base-devel --noconfirm
echo
echo
echo
echo
