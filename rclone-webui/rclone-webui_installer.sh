#!/bin/bash

# begin of variables
var_local_ip=$(ip route get 1.1.1.1 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
var_service_default_port="5572"
var_service_dependencies="rclone"
var_service_friendly_name="Rclone WebUI"
var_service_friendly_name_length=${var_service_friendly_name//?/=}
var_service_name="rclone-webui"
# end of variables

clear
echo "====================${var_service_friendly_name_length}============="
echo "== Arch Linux LXC - ${var_service_friendly_name} Installer =="
echo "====================${var_service_friendly_name_length}============="
echo
echo "This script will install ${var_service_friendly_name}."
echo
read -p "Press ENTER to start the script."
echo
echo
echo
echo

echo "Installing ${var_service_friendly_name}..."
echo "===========${var_service_friendly_name_length}==="
read -p "Press ENTER to continue..."
echo
echo "Installing ${var_service_friendly_name}..."
pacman -Syu --needed --noconfirm ${var_service_dependencies}
echo
echo
echo
echo

echo "Configuring ${var_service_friendly_name}..."
echo "============${var_service_friendly_name_length}==="
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
ExecStart=rclone rcd --rc-addr 0.0.0.0:${var_service_default_port} --rc-cert /var/lib/${var_service_name}/ssl/cert.pem --rc-key /var/lib/${var_service_name}/ssl/key.pem --rc-min-tls-version tls1.3 --rc-no-auth --rc-web-gui --rc-web-gui-no-open-browser
Restart=always
RestartSec=5s
TimeoutSec=20

[Install]
WantedBy=multi-user.target
EOF
echo
echo "Generating self-signed SSL certificate..."
mkdir -p /var/lib/${var_service_name}/ssl
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/${var_service_name}/ssl/key.pem -out /var/lib/${var_service_name}/ssl/cert.pem &> /dev/null
chown -R ${var_service_name}:${var_service_name} /var/lib/${var_service_name}/ssl
chmod 0755 /var/lib/${var_service_name}/ssl
chmod 0640 /var/lib/${var_service_name}/ssl/*
echo
echo "Enabling ${var_service_friendly_name}..."
chown -R ${var_service_name}:${var_service_name} /var/lib/${var_service_name}
systemctl enable ${var_service_name} &> /dev/null
echo
echo
echo
echo

echo "Starting ${var_service_friendly_name}..."
echo "=========${var_service_friendly_name_length}==="
echo "The installation and configuration of ${var_service_friendly_name} is complete."
echo "Proceed to start ${var_service_friendly_name}."
echo
read -p "Press ENTER to continue..."
echo
systemctl start ${var_service_name}
echo "Waiting 5 seconds for ${var_service_friendly_name} to start..."
sleep 5
echo
echo "You can now access the ${var_service_friendly_name} web interface."
echo "https://$var_local_ip:$var_service_default_port"
echo
echo "Proceed to display the service status and end the script."
echo
read -p "Press ENTER to continue..."
echo
systemctl status ${var_service_name}
