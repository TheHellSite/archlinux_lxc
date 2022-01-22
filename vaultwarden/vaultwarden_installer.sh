#!/bin/bash

# begin of variables
var_service_name="vaultwarden"
var_service_friendly_name="Vaultwarden"
var_service_friendly_name_length="==========="
var_service_default_https_port="8000"
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
pacman -Syyu --needed --noconfirm vaultwarden vaultwarden-web
echo
echo
echo
echo

echo "Configuring $var_service_friendly_name..."
echo "============$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo "Enabling Web Vault..."
sed -i 's@^# IP_HEADER=.*@IP_HEADER=X-Forwarded-For@' /etc/vaultwarden.env
sed -i 's@^# WEB_VAULT_FOLDER=.*@WEB_VAULT_FOLDER=/usr/share/webapps/vaultwarden-web@' /etc/vaultwarden.env
sed -i 's@^WEB_VAULT_ENABLED=.*@WEB_VAULT_ENABLED=true@' /etc/vaultwarden.env
echo
echo "Enabling Admin Interface..."
admin_token_var=`openssl rand -base64 48`
sed -i "s@^# ADMIN_TOKEN=.*@ADMIN_TOKEN=$admin_token_var@" /etc/vaultwarden.env
echo
echo "Configuring Domain..."
echo "Please enter your Vaultwarden domain."
echo 'For example: "https://vaultwarden.domain.tld"'
echo
read -p 'Vaultwarden domain: ' domain_var
sed -i "s@^# DOMAIN=.*@DOMAIN=$domain_var@" /etc/vaultwarden.env
echo
echo "Generating self-signed SSL certificate..."
mkdir -p /var/lib/vaultwarden/ssl
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/vaultwarden/ssl/key.pem -out /var/lib/vaultwarden/ssl/cert.pem
chown -R vaultwarden:vaultwarden /var/lib/vaultwarden/ssl
echo
echo "Configuring Rocket web framework..."
sed -i 's@^# ROCKET_ADDRESS=.*@ROCKET_ADDRESS=0.0.0.0@' /etc/vaultwarden.env

#sed -i 's@^# ROCKET_PORT=.*@ROCKET_PORT=443@' /etc/vaultwarden.env

sed -i 's@^# ROCKET_TLS=.*@ROCKET_TLS={certs="/var/lib/vaultwarden/ssl/cert.pem",key="/var/lib/vaultwarden/ssl/key.pem"}@' /etc/vaultwarden.env
echo
echo "Configuring SMTP..."
echo "Please enter your SMTP settings."
echo
read -p 'SMTP Server: ' smtp_server_var
read -p 'Email Address: ' smtp_email_address_var
# read -p 'Password: ' smtp_password_var
smtp_password_var="password"
echo
echo "!!! Attention !!!"
echo 'Unable to save passwords as they might contain special characters which "sed" cannot handle properly.'
echo 'Please provide the correct password using "nano /etc/vaultwarden.env".'
echo 'Place the password in "SMTP_PASSWORD=password".'
echo "!!! Attention !!!"
echo
read -p "Press ENTER to finish configuring SMTP..."
sed -i "s;^# SMTP_HOST=.*;SMTP_HOST=$smtp_server_var;" /etc/vaultwarden.env
sed -i "s;^# SMTP_FROM=.*;SMTP_FROM=$smtp_email_address_var;" /etc/vaultwarden.env
sed -i 's@^# SMTP_FROM_NAME=.*@SMTP_FROM_NAME=Vaultwarden@' /etc/vaultwarden.env
sed -i 's@^# SMTP_PORT=.*@SMTP_PORT=587@' /etc/vaultwarden.env
sed -i 's@^# SMTP_SSL=.*@SMTP_SSL=true@' /etc/vaultwarden.env
sed -i 's@^# SMTP_EXPLICIT_TLS=.*@SMTP_EXPLICIT_TLS=false@' /etc/vaultwarden.env
sed -i "s;^# SMTP_USERNAME=.*;SMTP_USERNAME=$smtp_email_address_var;" /etc/vaultwarden.env
sed -i "s@^# SMTP_PASSWORD=.*@SMTP_PASSWORD=$smtp_password_var@" /etc/vaultwarden.env
sed -i 's@^# SMTP_TIMEOUT=.*@SMTP_TIMEOUT=15@' /etc/vaultwarden.env
sed -i 's@^# SMTP_AUTH_MECHANISM=.*@SMTP_AUTH_MECHANISM="Login"@' /etc/vaultwarden.env
sed -i 's@^# HELO_NAME=.*@HELO_NAME=@' /etc/vaultwarden.env
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
systemctl enable --now $var_service_name
echo "Waiting 5 seconds for $var_service_friendly_name to start..."
sleep 5
echo
echo "You can now access the $var_service_friendly_name web interface to perform the final setup."
echo "https://$var_local_ip:$var_service_default_https_port"
echo
echo "Proceed to display the service status and end the script."
echo
read -p "Press ENTER to continue..."
echo
systemctl status $var_service_name
