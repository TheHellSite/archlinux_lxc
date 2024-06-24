#!/bin/bash

# begin of variables
var_service_name="filebrowser"
var_service_friendly_name="File Browser"
var_service_friendly_name_length="============"
var_service_default_port="8443"
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
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | /bin/bash
echo
echo
echo
echo

echo "Configuring $var_service_friendly_name..."
echo "============$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo 'Creating user "filebrowser"...'
useradd -r -d /var/lib/filebrowser -s /usr/bin/nologin filebrowser
echo
echo 'Creating service "filebrowser"...'
cat > /etc/systemd/system/filebrowser.service << EOF
[Unit]
Description=File Browser
After=network.target

[Service]
Type=simple
User=filebrowser
Group=filebrowser
ExecStart=/usr/local/bin/filebrowser -c /var/lib/filebrowser/.filebrowser.yaml
Restart=on-abort
TimeoutSec=20

[Install]
WantedBy=multi-user.target
EOF
echo
echo "Generating self-signed SSL certificate..."
mkdir -p /var/lib/filebrowser/ssl
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/filebrowser/ssl/key.pem -out /var/lib/filebrowser/ssl/cert.pem &> /dev/null
chown -R filebrowser:filebrowser /var/lib/filebrowser
chmod 0755 /var/lib/filebrowser/ssl
chmod 0640 /var/lib/filebrowser/ssl/*
echo
echo "Creating config file..."
mkdir -p /var/lib/filebrowser
cat > /var/lib/filebrowser/.filebrowser.yaml << EOF
address: '0.0.0.0'
baseURL: ''
cert: '/var/lib/filebrowser/ssl/cert.pem'
database: '/var/lib/filebrowser/database.db'
key: '/var/lib/filebrowser/ssl/key.pem'
log: 'stdout'
port: '8443'
root: '/var/lib/filebrowser'
EOF
echo
echo "Enabling service $var_service_friendly_name..."
systemctl enable $var_service_name &> /dev/null
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
