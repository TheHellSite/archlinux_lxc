#!/bin/bash

clear
echo "======================================="
echo "== Arch Linux LXC Jellyfin Installer =="
echo "======================================="
echo
echo "This script will install Jellyfin."
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

echo "Installing Jellyfin..."
echo "======================"
read -p "Press ENTER to continue..."
echo
git clone https://aur.archlinux.org/jellyfin-bin.git
cd jellyfin-bin
makepkg -sirc --noconfirm
cd
sudo rm -r jellyfin-bin
echo
echo
echo
echo

echo "Configuring Jellyfin..."
echo "======================="
read -p "Press ENTER to continue..."
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
echo "Generating self-signed SSL certificate..."
sudo mkdir -p /var/lib/jellyfin/ssl
sudo openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/jellyfin/ssl/key.pem -out /var/lib/jellyfin/ssl/cert.pem
sudo openssl pkcs12 -export -inkey /var/lib/jellyfin/ssl/key.pem -in /var/lib/jellyfin/ssl/cert.pem -out /var/lib/jellyfin/ssl/cert.pfx -passout pass:
sudo rm /var/lib/jellyfin/ssl/*.pem
sudo chown -R jellyfin:jellyfin /var/lib/jellyfin/ssl
echo
echo "Enabling HTTPS..."
sudo sed -i 's@^  <CertificatePath />@  <CertificatePath>/var/lib/jellyfin/ssl/cert.pfx</CertificatePath>@' /var/lib/jellyfin/config/network.xml
sudo sed -i 's@^  <EnableHttps>false</EnableHttps>@  <EnableHttps>true</EnableHttps>@' /var/lib/jellyfin/config/network.xml
sudo sed -i 's@^  <RequireHttps>false</RequireHttps>@  <RequireHttps>true</RequireHttps>@' /var/lib/jellyfin/config/network.xml
echo
echo
echo
echo

echo "Enabling and starting Jellyfin..."
echo "================================="
echo "The installation and configuration of Jellyfin is complete."
echo "Proceed to start Jellyfin and display the service status."
echo
read -p "Press ENTER to continue..."
echo
sudo systemctl start jellyfin
echo "Waiting 5 seconds for Jellyfin to start..."
sleep 5
echo
sudo systemctl status jellyfin
