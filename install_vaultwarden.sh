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
# ANPASSEN # ANPASSEN # ANPASSEN # ANPASSEN # ANPASSEN # ANPASSEN # ANPASSEN # ANPASSEN 
sed -i 's@WEB_VAULT_ENABLED=false@WEB_VAULT_ENABLED=true@' /etc/vaultwarden.env
sed -i 's@WEB_VAULT_ENABLED=false@WEB_VAULT_ENABLED=true@' /etc/vaultwarden.env
# ANPASSEN # ANPASSEN # ANPASSEN # ANPASSEN # ANPASSEN # ANPASSEN # ANPASSEN # ANPASSEN 
systemctl enable --now vaultwarden
