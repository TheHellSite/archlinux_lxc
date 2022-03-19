#!/bin/bash

# begin of variables
var_service_name="sonarr"
var_service_friendly_name="Sonarr"
var_service_friendly_name_length="======"
var_service_default_port="9898"
var_local_ip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
var_local_subnet=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}' | sed 's@[^.]*$@0/24@')
# end of variables

clear
echo "====================$var_service_friendly_name_length============="
echo "== Arch Linux LXC - $var_service_friendly_name Installer =="
echo "====================$var_service_friendly_name_length============="
echo
echo "This script will install $var_service_friendly_name."
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

echo "Installing $var_service_friendly_name..."
echo "===========$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
git clone https://aur.archlinux.org/sonarr.git
cd sonarr
makepkg -sirc --noconfirm
cd
sudo rm -r sonarr
echo
echo
echo
echo

echo "Configuring $var_service_friendly_name..."
echo "============$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo "Enabling and starting $var_service_friendly_name to generate config files..."
sudo systemctl enable --now $var_service_name &> /dev/null
echo
echo "Waiting 10 seconds for $var_service_friendly_name to start..."
sleep 10
echo
echo "Stopping $var_service_friendly_name to edit config files..."
sudo systemctl stop $var_service_name
echo
# temp temp temp
sudo systemctl stop sonarr
# temp temp temp
echo "Generating self-signed SSL certificate..."
sudo mkdir -p /var/lib/sonarr/ssl
sudo openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/sonarr/ssl/key.pem -out /var/lib/sonarr/ssl/cert.pem &> /dev/null
sudo openssl rsa -in /var/lib/sonarr/ssl/key.pem -outform pvk -pvk-none -out /var/lib/sonarr/ssl/key.pvk &> /dev/null
sudo openssl x509 -inform pem -in /var/lib/sonarr/ssl/cert.pem -outform der -out /var/lib/sonarr/ssl/cert.crt &> /dev/null
sudo rm /var/lib/sonarr/ssl/*.pem
sudo chown -R sonarr:sonarr /var/lib/sonarr/ssl
sudo chmod 0750 /var/lib/sonarr/ssl
sudo chmod 0640 /var/lib/sonarr/ssl/*
echo
echo "Enabling HTTPS..."
sudo su -s /bin/bash -c "httpcfg -add -port 9898 -pvk /var/lib/sonarr/ssl/key.pvk -cert /var/lib/sonarr/ssl/cert.crt" sonarr
sudo sed -i 's@^   <EnableSsl>False</EnableSsl>@   <EnableSsl>True</EnableSsl>@' /var/lib/sonarr/config.xml
#   <EnableSsl>False</EnableSsl>
#/var/lib/sonarr/config.xml
# temp temp temp
sudo systemctl start sonarr
# temp temp temp
echo
echo
echo
echo

echo "Starting $var_service_friendly_name..."
echo "=========$var_service_friendly_name_length==="
echo "The installation and configuration of $var_service_friendly_name is complete."
echo "Proceed to start $var_service_friendly_name."
echo
read -p "Press ENTER to continue..."
echo
sudo systemctl start $var_service_name
echo "Waiting 5 seconds for $var_service_friendly_name to start..."
sleep 5
echo
echo "You can now access the $var_service_friendly_name web interface."
echo "https://$var_local_ip:$var_service_default_port"
echo
echo "Proceed to display the service status and end the script."
echo
read -p "Press ENTER to continue..."
echo
sudo systemctl status $var_service_name
