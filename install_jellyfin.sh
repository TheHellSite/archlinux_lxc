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
mkdir git
cd git
git clone https://aur.archlinux.org/jellyfin-bin.git
cd jellyfin-bin
makepkg -sirc
cd
sudo rm -r git
echo
echo
echo

echo "Configuring Jellyfin..."
echo "======================="
read -p "Press ENTER to start..."
echo
echo "Enabling and starting Jellyfin to generate config files..."
sudo systemctl enable --now jellyfin
echo

echo "Waiting 10 seconds for Jellyfin to start..."
sleep 10
echo

echo "Stopping Jellyfin to edit config files..."
sudo systemctl stop jellyfin
echo

echo "Enabling HTTPS..."
sudo mkdir /var/lib/jellyfin/ssl
sudo openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/jellyfin/ssl/key.pem -out /var/lib/jellyfin/ssl/cert.pem
sudo openssl pkcs12 -export -inkey /var/lib/jellyfin/ssl/key.pem -in /var/lib/jellyfin/ssl/cert.pem -out /var/lib/jellyfin/ssl/jellyfin.pfx -passout pass:
sudo chown -R /var/lib/jellyfin/ssl
echo

CHANGE CONFIG


echo "Starting Jellyfin..."
sudo systemctl start jellyfin
echo "Waiting 5 seconds for Jellyfin to start..."
sleep 5
sudo systemctl status jellyfin
echo

echo
echo
echo
