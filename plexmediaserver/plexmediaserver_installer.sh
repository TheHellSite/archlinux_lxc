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
var_local_ip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
var_local_subnet=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}' | sed 's@[^.]*$@0/24@')
echo "Please enter a comma-separated list of IPs or subnets that are allowed without authentication."
echo "You should at least specify the IP or subnet of the machine you are currently typing on in order to access the web interface after the installation."
echo "For example: $var_local_ip,$var_local_subnet"
echo
read -p 'No auth IPs / subnets: ' var_no_auth
echo
echo "[OPTIONAL] Please provide a directory for temporary transcode files."
echo "[OPTIONAL] For example: /mnt/transcodes"
echo
read -p 'Path (leave empty for default): ' var_transcodes
var_search_string='MetricsEpoch="1"'
if [ -z "$var_transcodes" ]; then
    var_replace_string='MetricsEpoch="1" EnableIPv6="0" secureConnections="0" DisableTLSv1_0="1" GdmEnabled="0" RelayEnabled="0" customConnections="http://var_local_ip/,https://var_local_ip/" allowedNetworks="var_no_auth" WebHooksEnabled="0" TranscoderQuality="1"'
    sudo sed -i "s@$var_search_string@$var_replace_string@g" /var/lib/plex/Plex\ Media\ Server/Preferences.xml
    sudo sed -i "s@var_local_ip@$var_local_ip@g" /var/lib/plex/Plex\ Media\ Server/Preferences.xml
    sudo sed -i "s@var_no_auth@$var_no_auth@g" /var/lib/plex/Plex\ Media\ Server/Preferences.xml
else
    var_replace_string='MetricsEpoch="1" EnableIPv6="0" secureConnections="0" DisableTLSv1_0="1" GdmEnabled="0" RelayEnabled="0" customConnections="http://var_local_ip/,https://var_local_ip/" allowedNetworks="var_no_auth" WebHooksEnabled="0" TranscoderQuality="1" TranscoderTempDirectory="var_transcodes"'
    sudo sed -i "s@$var_search_string@$var_replace_string@g" /var/lib/plex/Plex\ Media\ Server/Preferences.xml
    sudo sed -i "s@var_local_ip@$var_local_ip@g" /var/lib/plex/Plex\ Media\ Server/Preferences.xml
    sudo sed -i "s@var_no_auth@$var_no_auth@g" /var/lib/plex/Plex\ Media\ Server/Preferences.xml
    sudo sed -i "s@var_transcodes@$var_transcodes@g" /var/lib/plex/Plex\ Media\ Server/Preferences.xml
fi
echo
echo
echo
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
