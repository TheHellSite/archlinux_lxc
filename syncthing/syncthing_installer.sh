#!/bin/bash

# begin of variables
var_service_name="syncthing"
var_service_friendly_name="Syncthing"
var_service_friendly_name_length="========="
var_service_default_port="8384"
var_local_ip=$(ip route get 1.1.1.1 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
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

echo "Installing $var_service_friendly_name..."
echo "===========$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo "Installing $var_service_friendly_name..."
pacman -Syu --needed --noconfirm syncthing
echo
echo
echo
echo

echo "Configuring $var_service_friendly_name..."
echo "============$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo 'Creating user "syncthing"...'
useradd -r -d /var/lib/syncthing -s /usr/bin/nologin syncthing
echo
echo 'Creating service "syncthing"...'
cat > /etc/systemd/system/syncthing.service << EOF
[Unit]
Description=Syncthing
After=network.target

[Service]
Type=simple
User=syncthing
Group=syncthing
ExecStart=/usr/bin/syncthing --home /var/lib/syncthing
Restart=always
RestartSec=5s
TimeoutSec=20

[Install]
WantedBy=multi-user.target
EOF
echo
echo "Enabling and starting $var_service_friendly_name to generate config files..."
mkdir -p /var/lib/syncthing
chown -R syncthing:syncthing /var/lib/syncthing
systemctl enable --now $var_service_name &> /dev/null
echo
echo "Waiting 10 seconds for $var_service_friendly_name to start..."
sleep 10
echo
echo "Stopping $var_service_friendly_name to edit config files..."
systemctl stop $var_service_name
echo
echo "Generating self-signed SSL certificate..."
mkdir -p /var/lib/syncthing/ssl
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/syncthing/ssl/key.pem -out /var/lib/syncthing/ssl/cert.pem &> /dev/null
chown -R syncthing:syncthing /var/lib/syncthing/ssl
chmod 0755 /var/lib/syncthing/ssl
chmod 0640 /var/lib/syncthing/ssl/*
echo
echo "Configuring Syncthing..."
#
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
systemctl start $var_service_name
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
systemctl status $var_service_name
