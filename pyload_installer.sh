#!/bin/bash

clear
echo "====================================="
echo "== Arch Linux LXC pyLoad Installer =="
echo "====================================="
echo
echo "This script will install pyLoad."
echo
read -p "Press ENTER to start the script."
echo
echo
echo
echo

echo "Installing pyLoad..."
echo "===================="
read -p "Press ENTER to continue..."
echo
echo "Installing dependencies..."
pacman -Syyu --noconfirm gcc python-pip
echo
echo "Installing pyLoad..."
pip install pyload-ng[plugins]
echo
echo
echo
echo

echo "Configuring pyLoad..."
echo "====================="
read -p "Press ENTER to continue..."
echo
echo "Creating user "pyload"..."
useradd -rU -d /var/lib/pyload/ -s /usr/bin/nologin pyload
echo
echo "Creating pyLoad service..."
cat <<EOF >/usr/lib/systemd/system/pyload.service
[Unit]
Description=pyLoad
After=network.target

[Service]
User=pyload
ExecStart=/usr/bin/pyload --userdir /var/lib/pyload/
Restart=on-abort
TimeoutSec=20

[Install]
WantedBy=multi-user.target
EOF
echo
echo "Enabling and starting pyLoad to generate config files..."
mkdir -p /var/lib/pyload
systemctl enable --now pyload
echo
echo "Waiting 10 seconds for pyLoad to start..."
sleep 10
echo
echo "Stopping pyLoad to edit config files..."
systemctl stop pyload
echo
echo "Generating self-signed SSL certificate..."
mkdir /var/lib/pyload/ssl
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/pyload/ssl/key.pem -out /var/lib/pyload/ssl/cert.pem
chown -R pyload:pyload /var/lib/pyload/ssl
echo
echo "Enabling HTTPS..."
#sudo sed -i 's@^  <CertificatePath />@  <CertificatePath>/var/lib/jellyfin/ssl/cert.pfx</CertificatePath>@' /var/lib/jellyfin/config/network.xml
#sudo sed -i 's@^  <EnableHttps>false</EnableHttps>@  <EnableHttps>true</EnableHttps>@' /var/lib/jellyfin/config/network.xml
#sudo sed -i 's@^  <RequireHttps>false</RequireHttps>@  <RequireHttps>true</RequireHttps>@' /var/lib/jellyfin/config/network.xml
echo
echo
echo
echo
