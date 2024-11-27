#!/bin/bash

# begin of variables
var_local_ip=$(ip route get 1.1.1.1 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
var_service_default_port="8080"
var_service_dependencies="p7zip python python-pip python-setuptools unrar"
var_service_download_url=$(curl -s https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest | grep 'browser_download_url' | grep 'src.tar.gz' | cut -d\" -f4)
var_service_friendly_name="SABnzbd"
var_service_friendly_name_length=${var_service_friendly_name//?/=}
var_service_name=${var_service_friendly_name,,}
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
echo "Installing dependencies..."
pacman -Syu --needed --noconfirm ${var_service_dependencies}
echo
echo "Installing par2cmdline-turbo..."
mkdir -p /tmp/${var_service_name}_installer
var_par2cmdlineturbo_download_url=$(curl -s https://api.github.com/repos/animetosho/par2cmdline-turbo/releases/latest | grep 'browser_download_url' | grep 'linux-amd64.xz' | cut -d\" -f4)
curl -L -o /tmp/${var_service_name}_installer/par2cmdline-turbo_latest_linux.xz "${var_par2cmdlineturbo_download_url}"
xz -dc /tmp/${var_service_name}_installer/par2cmdline-turbo_latest_linux.xz > /usr/bin/par2
chmod +x /usr/bin/par2
echo
echo "Installing ${var_service_friendly_name}..."
mkdir -p /tmp/${var_service_name}_installer/${var_service_name}
curl -L -o /tmp/${var_service_name}_installer/${var_service_name}_latest_linux.tar.gz "${var_service_download_url}"
tar -xzf /tmp/${var_service_name}_installer/${var_service_name}_latest_linux.tar.gz --strip-components=1 -C /tmp/${var_service_name}_installer/${var_service_name}
mv /tmp/${var_service_name}_installer/${var_service_name} /opt/${var_service_name}
python -m venv /opt/${var_service_name}/python_venv
source /opt/${var_service_name}/python_venv/bin/activate
python -m pip install --upgrade pip wheel
python -m pip install --cache-dir /tmp/${var_service_name}_installer/pip-cache -r /opt/${var_service_name}/requirements.txt
deactivate
rm -r /tmp/${var_service_name}_installer
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
ExecStart=/opt/${var_service_name}/python_venv/bin/python3 /opt/${var_service_name}/SABnzbd.py -s 0.0.0.0:8080 -f /var/lib/${var_service_name}/sabnzbd.ini
Restart=always
RestartSec=5s
TimeoutSec=20

[Install]
WantedBy=multi-user.target
EOF
echo
echo "Enabling and starting ${var_service_friendly_name} to generate config files..."
mkdir -p /var/lib/${var_service_name}
chown -R ${var_service_name}:${var_service_name} /opt/${var_service_name} /var/lib/${var_service_name}
systemctl enable --now ${var_service_name} &> /dev/null
echo
echo "Waiting 10 seconds for ${var_service_friendly_name} to start..."
sleep 10
echo
echo "Stopping ${var_service_friendly_name} to edit config files..."
systemctl stop ${var_service_name}
echo
echo "Generating self-signed SSL certificate..."
mkdir -p /var/lib/${var_service_name}/ssl
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/${var_service_name}/ssl/server.key -out /var/lib/${var_service_name}/ssl/server.cert &> /dev/null
chown -R ${var_service_name}:${var_service_name} /var/lib/${var_service_name}/ssl
chmod 0755 /var/lib/${var_service_name}/ssl
chmod 0640 /var/lib/${var_service_name}/ssl/*
echo
echo "Enabling HTTPS..."
sed -i "s@https_cert = server.cert@https_cert = /var/lib/${var_service_name}/ssl/server.cert@" /var/lib/${var_service_name}/sabnzbd.ini
sed -i "s@https_key = server.key@https_key = /var/lib/${var_service_name}/ssl/server.key@" /var/lib/${var_service_name}/sabnzbd.ini
sed -i 's@enable_https = 0@enable_https = 1@' /var/lib/${var_service_name}/sabnzbd.ini
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
