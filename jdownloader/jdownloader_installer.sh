#!/bin/bash

# begin of variables
var_service_name="jdownloader"
var_service_friendly_name="JDownloader"
var_service_friendly_name_length="==========="
var_service_default_port="0"
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
echo "Installing dependencies..."
pacman -Syyu --needed --noconfirm jre-openjdk-headless
echo
echo "Installing $var_service_friendly_name..."
mkdir -p /var/lib/jdownloader
curl https://installer.jdownloader.org/JDownloader.jar -o JDownloader.jar
echo
echo
echo
echo

echo "Configuring $var_service_friendly_name..."
echo "============$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo 'Creating user "jdownloader"...'
useradd -rU -d /var/lib/jdownloader -s /usr/bin/nologin jdownloader
echo
echo 'Creating service "jdownloader"...'
cat > /etc/systemd/system/jdownloader.service << EOF
[Unit]
Description=JDownloader
After=network.target

[Service]
Type=simple
User=jdownloader
Group=jdownloader
ExecStart=/usr/bin/java -Djava.awt.headless=true -jar --userdir /var/lib/jdownloader/JDownloader.jar
Restart=on-abort
TimeoutSec=20

[Install]
WantedBy=multi-user.target
EOF
echo
echo "Enabling and starting $var_service_friendly_name to generate config files..."
mkdir -p /var/lib/pyload
chown -R pyload:pyload /var/lib/pyload
systemctl enable --now $var_service_name &> /dev/null
echo
echo "Waiting 10 seconds for $var_service_friendly_name to start..."
sleep 10
echo
echo "Stopping $var_service_friendly_name to edit config files..."
systemctl stop $var_service_name
echo
echo "Generating self-signed SSL certificate..."
mkdir -p /var/lib/pyload/ssl
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/pyload/ssl/key.pem -out /var/lib/pyload/ssl/cert.pem &> /dev/null
chown -R pyload:pyload /var/lib/pyload/ssl
chmod 0755 /var/lib/pyload/ssl
chmod 0640 /var/lib/pyload/ssl/*
echo
echo "Configuring Download..."
mkdir -p /tmp/pyload
sed -i 's@int chunks : "Maximum connections for one download" =.*@int chunks : "Maximum connections for one download" = 4@' /var/lib/pyload/settings/pyload.cfg
sed -i 's@ip interface : "Download interface to bind (IP Address)" =.*@ip interface : "Download interface to bind (IP Address)" = 0.0.0.0@' /var/lib/pyload/settings/pyload.cfg
sed -i 's@int max_downloads : "Maximum parallel downloads" =.*@int max_downloads : "Maximum parallel downloads" = 4@' /var/lib/pyload/settings/pyload.cfg
sed -i 's@bool skip_existing : "Skip already existing files" =.*@bool skip_existing : "Skip already existing files" = True@' /var/lib/pyload/settings/pyload.cfg
echo
echo "Configuring General..."
sed -i 's@bool debug_mode : "Debug mode" =.*@bool debug_mode : "Debug mode" = False@' /var/lib/pyload/settings/pyload.cfg
sed -i 's@folder storage_folder : "Download folder" =.*@folder storage_folder : "Download folder" = /tmp/pyload@' /var/lib/pyload/settings/pyload.cfg
echo
echo "Configuring Web Interface..."
sed -i 's@bool develop : "Development mode" =.*@bool develop : "Development mode" = False@' /var/lib/pyload/settings/pyload.cfg
sed -i 's@ip host : "IP address" =.*@ip host : "IP address" = 0.0.0.0@' /var/lib/pyload/settings/pyload.cfg
sed -i 's@file ssl_certchain : "CA'\''s intermediate certificate bundle (optional)" =.*@file ssl_certchain : "CA'\''s intermediate certificate bundle (optional)" =@' /var/lib/pyload/settings/pyload.cfg
sed -i 's@file ssl_certfile : "SSL Certificate" =.*@file ssl_certfile : "SSL Certificate" = /var/lib/pyload/ssl/cert.pem@' /var/lib/pyload/settings/pyload.cfg
sed -i 's@file ssl_keyfile : "SSL Key" =.*@file ssl_keyfile : "SSL Key" = /var/lib/pyload/ssl/key.pem@' /var/lib/pyload/settings/pyload.cfg
sed -i 's@bool use_ssl : "Use HTTPS" =.*@bool use_ssl : "Use HTTPS" = True@' /var/lib/pyload/settings/pyload.cfg
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
