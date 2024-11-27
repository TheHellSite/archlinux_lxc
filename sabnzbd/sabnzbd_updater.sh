#!/bin/bash

# begin of variables
var_local_ip=$(ip route get 1.1.1.1 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
var_service_default_port="8080"
var_service_download_url=$(curl -s https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest | grep 'browser_download_url' | grep 'src.tar.gz' | cut -d\" -f4)
var_service_friendly_name="SABnzbd"
var_service_friendly_name_length=${var_service_friendly_name//?/=}
var_service_name=${var_service_friendly_name,,}
# end of variables

clear
echo "====================${var_service_friendly_name_length}==========="
echo "== Arch Linux LXC - ${var_service_friendly_name} Updater =="
echo "====================${var_service_friendly_name_length}==========="
echo
echo "This script will update ${var_service_friendly_name}."
echo
read -p "Press ENTER to start the script."
echo
echo
echo
echo

echo "Updating ${var_service_friendly_name}..."
echo "=========${var_service_friendly_name_length}==="
read -p "Press ENTER to continue..."
echo
echo "Stopping ${var_service_friendly_name}..."
systemctl stop ${var_service_name}
echo
echo "Updating par2cmdline-turbo..."
mkdir -p /tmp/${var_service_name}_installer
var_par2cmdlineturbo_download_url=$(curl -s https://api.github.com/repos/animetosho/par2cmdline-turbo/releases/latest | grep 'browser_download_url' | grep 'linux-amd64.xz' | cut -d\" -f4)
curl -L -o /tmp/${var_service_name}_installer/par2cmdline-turbo_latest_linux.xz "${var_par2cmdlineturbo_download_url}"
xz -dc /tmp/${var_service_name}_installer/par2cmdline-turbo_latest_linux.xz > /usr/bin/par2
chmod +x /usr/bin/par2
echo
echo "Updating ${var_service_friendly_name}..."
rm -r /opt/${var_service_name}
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

echo "Restarting ${var_service_friendly_name}..."
echo "===========${var_service_friendly_name_length}==="
echo "The ${var_service_friendly_name} update is complete."
echo "Proceed to start ${var_service_friendly_name} and display the service status."
echo
read -p "Press ENTER to continue..."
echo
systemctl start ${var_service_name}
echo "Waiting 5 seconds for ${var_service_friendly_name} to start..."
sleep 5
echo
systemctl status ${var_service_name}
