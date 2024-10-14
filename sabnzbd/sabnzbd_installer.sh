#!/bin/bash

# begin of variables
var_service_name="sabnzbd"
var_service_friendly_name="SABnzbd"
var_service_friendly_name_length="======="
var_service_default_port="8080"
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
pacman -Syu --needed --noconfirm base-devel ffmpeg git par2cmdline p7zip python python-pip python-wheel unrar unzip
echo
echo "Installing $var_service_friendly_name..."
git clone https://github.com/sabnzbd/sabnzbd.git /var/lib/${var_service_name}/git
# Create python venv
python3 -m venv /var/lib/${var_service_name}/venv
source /var/lib/${var_service_name}/venv/bin/activate
# Install requirements into the venv
pip install --cache-dir /tmp/pip-cache -r /var/lib/${var_service_name}/git/requirements.txt
deactivate
echo
echo
echo
echo

echo "Configuring $var_service_friendly_name..."
echo "============$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo "Creating user \"${var_service_name}\"..."
useradd -r -d /var/lib/${var_service_name} -s /usr/bin/nologin ${var_service_name}
echo
echo "Creating service \"${var_service_name}\"..."
cat > /etc/systemd/system/${var_service_name}.service << EOF
[Unit]
Description=${var_service_friendly_name}
After=network.target

[Service]
Type=simple
User=${var_service_name}
Group=${var_service_name}
ExecStart=/var/lib/${var_service_name}/venv/bin/python3 /var/lib/${var_service_name}/git/SABnzbd.py -s 0.0.0.0:8080 -f /var/lib/${var_service_name}/config/sabnzbd.ini
Restart=always
RestartSec=5s
TimeoutSec=20

[Install]
WantedBy=multi-user.target
EOF
echo
echo "Enabling and starting ${var_service_friendly_name} to generate config files..."
mkdir -p /var/lib/${var_service_name}/config
chown -R ${var_service_name}:${var_service_name} /var/lib/${var_service_name}
systemctl enable --now ${var_service_name} &> /dev/null
echo
echo "Waiting 10 seconds for ${var_service_friendly_name} to start..."
sleep 10
echo
echo "Stopping ${var_service_friendly_name} to edit config files..."
systemctl stop ${var_service_name}
echo
echo "Generating self-signed SSL certificate..."
mkdir -p /var/lib/${var_service_name}/config/ssl
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/${var_service_name}/config/ssl/server.key -out /var/lib/${var_service_name}/config/ssl/server.cert &> /dev/null
chown -R ${var_service_name}:${var_service_name} /var/lib/${var_service_name}/config/ssl
chmod 0755 /var/lib/${var_service_name}/config/ssl
chmod 0640 /var/lib/${var_service_name}/config/ssl/*
echo
echo "Enabling HTTPS..."
sed -i "s@https_cert = server.cert@https_cert = /var/lib/${var_service_name}/config/ssl/server.cert@" /var/lib/${var_service_name}/config/sabnzbd.ini
sed -i "s@https_key = server.key@https_key = /var/lib/${var_service_name}/config/ssl/server.key@" /var/lib/${var_service_name}/config/sabnzbd.ini
sed -i 's@enable_https = 0@enable_https = 1@' /var/lib/${var_service_name}/config/sabnzbd.ini
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
