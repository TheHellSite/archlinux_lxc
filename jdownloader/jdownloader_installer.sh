#!/bin/bash

# begin of variables
var_service_name="jdownloader"
var_service_friendly_name="JDownloader"
var_service_friendly_name_length="==========="
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
pacman -Syu --needed --noconfirm jre-openjdk-headless ffmpeg
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
Restart=on-failure
RestartSec=5s
TimeoutSec=20

[Install]
WantedBy=multi-user.target
EOF
echo
echo 'Enabling service "jdownloader"...'
chown -R jdownloader:jdownloader /var/lib/jdownloader
systemctl enable $var_service_name &> /dev/null
echo
echo "Proceed to start JDownloader to generate config files and install all available updates..."
echo "This process can take a while depending on your internet speed!"
echo
read -p "Press ENTER to continue..."
echo
su - jdownloader -s /bin/bash -c "/usr/bin/java -Djava.awt.headless=true -jar /var/lib/jdownloader/JDownloader.jar -norestart"
echo
echo
echo
echo

echo "Starting $var_service_friendly_name..."
echo "=========$var_service_friendly_name_length==="
echo "The installation of $var_service_friendly_name is complete."
echo "Proceed to configure the MyJDownloader credentials and finish the configuration of $var_service_friendly_name."
echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo '!! 1. Connect your instance to "https://my.jdownloader.org/". !!'
echo '!! 2. Wait for "Update Message: Check for updates" to appear. !!'
echo '!! 3. Press "CTRL + C" to exit JDownloader.                   !!'
echo "!! 4. Reboot the LXC.                                         !!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo
read -p "Press ENTER to continue..."
echo
su - jdownloader -s /bin/bash -c "/usr/bin/java -Djava.awt.headless=true -jar /var/lib/jdownloader/JDownloader.jar"
