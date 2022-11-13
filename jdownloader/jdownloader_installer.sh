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
curl https://installer.jdownloader.org/JDownloader.jar -o /var/lib/jdownloader/JDownloader.jar
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
ExecStart=/usr/bin/java -Djava.awt.headless=true -jar /var/lib/jdownloader/JDownloader.jar
Restart=on-abort
TimeoutSec=20

[Install]
WantedBy=multi-user.target
EOF
echo
echo 'Enabling service "jdownloader"...'
chown -R jdownloader:jdownloader /var/lib/jdownloader
systemctl enable $var_service_name &> /dev/null
echo
echo "Starting JDownloader to install available updates and generate config files..."
echo "This process can take a while depending on your internet speed!"
echo
/usr/bin/java -Djava.awt.headless=true -jar /var/lib/jdownloader/JDownloader.jar -norestart
echo
echo
echo
echo

echo "Starting $var_service_friendly_name..."
echo "=========$var_service_friendly_name_length==="
echo "The installation and configuration of $var_service_friendly_name is almost complete."
echo "Proceed to start $var_service_friendly_name and enter your MyJDownloader credentials."
echo "After connecting your instance to MyJDownloader press CTRL+C and reboot the LXC."
echo
read -p "Press ENTER to continue..."
echo
/usr/bin/java -Djava.awt.headless=true -jar /var/lib/jdownloader/JDownloader.jar