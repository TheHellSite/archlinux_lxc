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

echo "Enabling Web Vault..."
sed -i 's@^# IP_HEADER=.*@IP_HEADER=X-Forwarded-For@' /etc/vaultwarden.env
sed -i 's@^# WEB_VAULT_FOLDER=.*@WEB_VAULT_FOLDER=/usr/share/webapps/vaultwarden-web@' /etc/vaultwarden.env
sed -i 's@^# WEB_VAULT_ENABLED=.*@WEB_VAULT_ENABLED=true@' /etc/vaultwarden.env
echo

echo "Enabling Admin Interface..."
admin_token_var=`openssl rand -base64 48`
sed -i "s@^# ADMIN_TOKEN=.*@ADMIN_TOKEN=$admin_token_var@" /etc/vaultwarden.env
echo "You Admin Token is: $admin_token_var"
echo

echo "Configuring Domain..."
echo "Please enter your Vaultwarden domain."
echo 'For example: "https://vaultwarden.domain.tld"'
echo
read -p 'Vaultwarden domain: ' domain_var
sed -i "s@^# DOMAIN=.*@DOMAIN=$domain_var@" /etc/vaultwarden.env
echo

echo "Generating self-signed SSL certificate..."
mkdir /var/lib/vaultwarden/ssl
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/vaultwarden/ssl/key.pem -out /var/lib/vaultwarden/ssl/cert.pem
chown -R vaultwarden:vaultwarden /var/lib/vaultwarden/ssl
echo

echo "Enabling HTTPS..."
sed -i 's@^# ROCKET_PORT=.*@ROCKET_PORT=443@' /etc/vaultwarden.env
sed -i 's@^# ROCKET_TLS=.*@ROCKET_TLS={certs="/var/lib/vaultwarden/ssl/cert.pem",key="/var/lib/vaultwarden/ssl/key.pem"}@' /etc/vaultwarden.env
echo

echo "Configuring SMTP..."
echo "Please enter your SMTP settings."
echo
read -p 'SMTP Server: ' smtp_server_var
read -p 'Email Address: ' smtp_email_address_var
read -p 'Password: ' smtp_password_var
sed -i "s@^# SMTP_HOST=.*@SMTP_HOST=$smtp_server_var@" /etc/vaultwarden.env
sed -i "s@^# SMTP_FROM=.*@SMTP_FROM=$smtp_email_address_var@" /etc/vaultwarden.env
sed -i 's@^# SMTP_FROM_NAME=.*@SMTP_FROM_NAME=Vaultwarden@' /etc/vaultwarden.env
sed -i 's@^# SMTP_PORT=.*@SMTP_PORT=587@' /etc/vaultwarden.env
sed -i 's@^# SMTP_SSL=.*@SMTP_SSL=true@' /etc/vaultwarden.env
sed -i 's@^# SMTP_EXPLICIT_TLS=.*@SMTP_EXPLICIT_TLS=false@' /etc/vaultwarden.env
sed -i "s@^# SMTP_USERNAME=.*@SMTP_USERNAME=$smtp_email_address_var@" /etc/vaultwarden.env
sed -i "s@^# SMTP_PASSWORD=.*@SMTP_PASSWORD=$smtp_password_var@" /etc/vaultwarden.env
sed -i 's@^# SMTP_TIMEOUT=.*@SMTP_TIMEOUT=15@' /etc/vaultwarden.env
sed -i 's@^# SMTP_AUTH_MECHANISM=.*@SMTP_AUTH_MECHANISM="Login"@' /etc/vaultwarden.env
sed -i 's@^# HELO_NAME=.*@# HELO_NAME=@' /etc/vaultwarden.env
echo

echo "Enabling and starting Vaultwarden..."
systemctl enable --now vaultwarden
echo
echo "Waiting 5 seconds for Vaultwarden to start..."
sleep 5
echo
systemctl status vaultwarden
