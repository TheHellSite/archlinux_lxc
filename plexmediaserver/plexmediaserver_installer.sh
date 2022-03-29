#!/bin/bash

# begin of variables
var_service_name="plexmediaserver"
var_service_friendly_name="Plex Media Server"
var_service_friendly_name_length="================="
var_service_default_port="32400"
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
git clone https://aur.archlinux.org/plex-media-server.git
cd plex-media-server
makepkg -sirc --noconfirm
cd
sudo rm -r plex-media-server
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
echo "[OPTIONAL] Please provide a directory for temporary transcode files."
echo "[OPTIONAL] For example: /mnt/transcodes"
echo
read -p 'Path (leave empty for default): ' var_transcodes
var_search_string='MetricsEpoch="1"'
if [ -z "$var_transcodes" ]; then
    var_replace_string='MetricsEpoch="1" EnableIPv6="0" secureConnections="0" DisableTLSv1_0="1" GdmEnabled="0" RelayEnabled="0" WebHooksEnabled="0" TranscoderQuality="1"'
    sudo sed -i "s@$var_search_string@$var_replace_string@g" /var/lib/plex/Plex\ Media\ Server/Preferences.xml
else
    var_replace_string='MetricsEpoch="1" EnableIPv6="0" secureConnections="0" DisableTLSv1_0="1" GdmEnabled="0" RelayEnabled="0" WebHooksEnabled="0" TranscoderQuality="1" TranscoderTempDirectory="var_transcodes"'
    sudo sed -i "s@$var_search_string@$var_replace_string@g" /var/lib/plex/Plex\ Media\ Server/Preferences.xml
    sudo sed -i "s@var_transcodes@$var_transcodes@g" /var/lib/plex/Plex\ Media\ Server/Preferences.xml
fi
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
echo "You can now access the $var_service_friendly_name web interface to perform the Server Setup."
echo "http://$var_local_ip:$var_service_default_port/web/index.html"
echo
echo "After finishing the Server Setup you can also access the web interface using https."
echo "https://$var_local_ip:$var_service_default_port/web/index.html"
echo
echo "Proceed to display the service status and end the script."
echo
read -p "Press ENTER to continue..."
echo
sudo systemctl status $var_service_name
