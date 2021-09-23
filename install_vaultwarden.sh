#!/bin/bash

clear
echo "============================================="
echo "== Arch Linux LXC Vaultwarden installation =="
echo "============================================="
echo
echo "This script will install Vaultwarden."
echo
read -p "Press ENTER to start the script."
echo
echo
echo

echo "Installing Vaultwarden..."
echo "========================="
read -p "Press ENTER to start..."
echo
pacman -S vaultwarden vaultwarden-web --noconfirm
echo
echo
echo

echo "Configuring Vaultwarden..."
echo "=========================="
read -p "Press ENTER to start..."
echo
echo "Generating SSL certificate..."
mkdir /var/lib/vaultwarden/ssl
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/vaultwarden/ssl/key.pem -out /var/lib/vaultwarden/ssl/cert.pem
chown -R vaultwarden:vaultwarden /var/lib/vaultwarden/ssl
echo
echo "Enabling Web Vault..."
sed -i 's@# WEB_VAULT_FOLDER=/usr/share/webapps/vaultwarden-web@WEB_VAULT_FOLDER=/usr/share/webapps/vaultwarden-web@' /etc/vaultwarden.env
sed -i 's@WEB_VAULT_ENABLED=false@WEB_VAULT_ENABLED=true@' /etc/vaultwarden.env
echo
echo "Enabling HTTPS..."
sed -i 's@# ROCKET_PORT=80  # Defaults to 80 in the Docker images, or 8000 otherwise.@ROCKET_PORT=443@' /etc/vaultwarden.env
sed -i 's@# ROCKET_TLS={certs="/path/to/certs.pem",key="/path/to/key.pem"}@ROCKET_TLS={certs="/var/lib/vaultwarden/ssl/cert.pem",key="/var/lib/vaultwarden/ssl/key.pem"}@' /etc/vaultwarden.env
echo
echo "Enabling and starting Vaultwarden..."
systemctl enable --now vaultwarden
echo
echo "Waiting 5 seconds for Vaultwarden to start..."
sleep 5
echo
systemctl status vaultwarden
