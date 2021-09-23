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
sed -i 's@# IP_HEADER=X-Real-IP@IP_HEADER=X-Forwarded-For@' /etc/vaultwarden.env
sed -i 's@# WEB_VAULT_FOLDER=/usr/share/webapps/vaultwarden-web@WEB_VAULT_FOLDER=/usr/share/webapps/vaultwarden-web@' /etc/vaultwarden.env
sed -i 's@WEB_VAULT_ENABLED=false@WEB_VAULT_ENABLED=true@' /etc/vaultwarden.env
echo

echo "Enabling Admin Interface..."
admin_token_var=`openssl rand -base64 48`
sed -i "s@# ADMIN_TOKEN=Vy2VyYTTsKPv8W5aEOWUbB/Bt3DEKePbHmI4m9VcemUMS2rEviDowNAFqYi1xjmp@ADMIN_TOKEN=$admin_token_var@" /etc/vaultwarden.env
echo "You Admin Token is: $admin_token_var"
echo

echo "Configuring Domain..."
echo "Please enter your Vaultwarden domain."
echo 'For example: "https://vaultwarden.domain.tld"'
echo
read -p 'Vaultwarden domain: ' domain_var
sed -i "s@# DOMAIN=https://bw.domain.tld:8443@DOMAIN=$domain_var@" /etc/vaultwarden.env
echo

echo "Generating self-signed SSL certificate..."
mkdir /var/lib/vaultwarden/ssl
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/vaultwarden/ssl/key.pem -out /var/lib/vaultwarden/ssl/cert.pem
chown -R vaultwarden:vaultwarden /var/lib/vaultwarden/ssl
echo

echo "Enabling HTTPS..."
sed -i 's@# ROCKET_PORT=80  # Defaults to 80 in the Docker images, or 8000 otherwise.@ROCKET_PORT=443@' /etc/vaultwarden.env
sed -i 's@# ROCKET_TLS={certs="/path/to/certs.pem",key="/path/to/key.pem"}@ROCKET_TLS={certs="/var/lib/vaultwarden/ssl/cert.pem",key="/var/lib/vaultwarden/ssl/key.pem"}@' /etc/vaultwarden.env
echo

echo "Configuring SMTP..."
echo "Please enter your SMTP settings."
echo
read -p 'SMTP Server: ' smtp_server_var
read -p 'Email Address: ' smtp_email_address_var
read -p 'Password: ' smtp_password_var
sed -i "s@# SMTP_HOST=smtp.domain.tld@SMTP_HOST=$smtp_server_var@" /etc/vaultwarden.env
sed -i "s@# SMTP_FROM=vaultwarden@domain.tld@SMTP_FROM=$smtp_email_address_var@" /etc/vaultwarden.env
sed -i 's@# SMTP_FROM_NAME=Vaultwarden@SMTP_FROM_NAME=Vaultwarden@' /etc/vaultwarden.env
sed -i 's@# SMTP_PORT=587          # Ports 587 (submission) and 25 (smtp) are standard without encryption and with encryption via STARTTLS (Explicit TLS). Port 465 is outdated and used with Implicit TLS.@SMTP_PORT=587@' /etc/vaultwarden.env
sed -i 's@# SMTP_SSL=true          # (Explicit) - This variable by default configures Explicit STARTTLS, it will upgrade an insecure connection to a secure one. Unless SMTP_EXPLICIT_TLS is set to true. Either port 587 or 25 are default.@SMTP_SSL=true@' /etc/vaultwarden.env
sed -i 's@# SMTP_EXPLICIT_TLS=true # (Implicit) - N.B. This variable configures Implicit TLS. It's currently mislabelled (see bug #851) - SMTP_SSL Needs to be set to true for this option to work. Usually port 465 is used here.@SMTP_EXPLICIT_TLS=false@' /etc/vaultwarden.env
sed -i "s@# SMTP_USERNAME=username@SMTP_USERNAME=$smtp_email_address_var@" /etc/vaultwarden.env
sed -i "s@# SMTP_PASSWORD=password@SMTP_PASSWORD=$smtp_password_var@" /etc/vaultwarden.env
sed -i 's@# SMTP_TIMEOUT=15@SMTP_TIMEOUT=15@' /etc/vaultwarden.env
sed -i 's@# SMTP_AUTH_MECHANISM="Plain"@SMTP_AUTH_MECHANISM="Login"@' /etc/vaultwarden.env
echo

echo "Enabling and starting Vaultwarden..."
systemctl enable --now vaultwarden
echo
echo "Waiting 5 seconds for Vaultwarden to start..."
sleep 5
echo
systemctl status vaultwarden
