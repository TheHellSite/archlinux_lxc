#!/bin/bash

# begin of variables
var_service_name="vaultwarden"
var_service_friendly_name="Vaultwarden"
var_service_friendly_name_length="==========="
var_service_default_port="8000"
var_local_ip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
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
pacman -Syu --needed --noconfirm vaultwarden vaultwarden-web
echo
echo
echo
echo

echo "Configuring $var_service_friendly_name..."
echo "============$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo "Enabling Web Vault..."
sed -i 's@^# WEB_VAULT_FOLDER=.*@WEB_VAULT_FOLDER=/usr/share/webapps/vaultwarden-web@' /etc/vaultwarden.env
sed -i 's@^WEB_VAULT_ENABLED=.*@# WEB_VAULT_ENABLED=true@' /etc/vaultwarden.env
echo
echo "Generating self-signed SSL certificate..."
mkdir -p /var/lib/vaultwarden/ssl
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/vaultwarden/ssl/key.pem -out /var/lib/vaultwarden/ssl/cert.pem &> /dev/null
chown -R vaultwarden:vaultwarden /var/lib/vaultwarden/ssl
chmod 0755 /var/lib/vaultwarden/ssl
chmod 0640 /var/lib/vaultwarden/ssl/*
echo
echo "Configuring Rocket web framework..."
sed -i 's@^# ROCKET_ADDRESS=.*@ROCKET_ADDRESS=0.0.0.0@' /etc/vaultwarden.env
sed -i 's@^# ROCKET_TLS=.*@ROCKET_TLS={certs="/var/lib/vaultwarden/ssl/cert.pem",key="/var/lib/vaultwarden/ssl/key.pem"}@' /etc/vaultwarden.env
echo
echo
echo
echo

echo "Enabling and starting $var_service_friendly_name..."
echo "======================$var_service_friendly_name_length==="
echo "The installation and configuration of $var_service_friendly_name is complete."
echo "Proceed to enable and start $var_service_friendly_name."
echo
read -p "Press ENTER to continue..."
echo
systemctl enable --now $var_service_name &> /dev/null
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
