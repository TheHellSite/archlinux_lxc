#!/bin/bash

clear
echo "====================================="
echo "== Arch Linux LXC pyLoad Installer =="
echo "====================================="
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
sudo pacman -Syyu --needed --noconfirm git base-devel
echo
echo
echo
echo

echo "Installing pyLoad dependencies..."
echo "================================="
read -p "Press ENTER to continue..."
echo
git clone https://aur.archlinux.org/python-bitmath.git
cd python-bitmath
makepkg -sirc --noconfirm
cd
sudo rm -r python-bitmath

git clone https://aur.archlinux.org/python-cachelib.git
cd python-cachelib
makepkg -sirc --noconfirm
cd
sudo rm -r python-cachelib

git clone https://aur.archlinux.org/python-flask-themes2.git
cd python-flask-themes2
makepkg -sirc --noconfirm
cd
sudo rm -r python-flask-themes2

git clone https://aur.archlinux.org/python-flask-session.git
cd python-flask-session
makepkg -sirc --noconfirm
cd
sudo rm -r python-flask-session

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
