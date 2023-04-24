#!/bin/bash

# begin of variables
var_service_name="bazarr"
var_service_friendly_name="Bazarr"
var_service_friendly_name_length="======"
var_service_default_port="6767"
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

echo "Preparing AUR..."
echo "================"
read -p "Press ENTER to continue..."
echo
sudo pacman -Syyu --needed --noconfirm git base-devel stunnel
echo
echo
echo
echo

echo "Installing $var_service_friendly_name..."
echo "===========$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo "Installing dependencies..."
git clone https://aur.archlinux.org/python-webrtcvad-wheels.git
cd python-webrtcvad-wheels
makepkg -sirc --noconfirm
cd
sudo rm -r python-webrtcvad-wheels
echo
echo "Installing $var_service_friendly_name..."
git clone https://aur.archlinux.org/bazarr.git
cd bazarr
makepkg -sirc --noconfirm
cd
sudo rm -r bazarr
echo
echo
echo
echo

echo "Configuring $var_service_friendly_name..."
echo "============$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo "Enabling and starting $var_service_friendly_name to generate config files..."
sudo systemctl enable --now $var_service_name &> /dev/null
echo
echo "Waiting 10 seconds for $var_service_friendly_name to start..."
sleep 10
echo
echo "Stopping $var_service_friendly_name to edit config files..."
sudo systemctl stop $var_service_name
echo
echo "Generating self-signed SSL certificate..."
sudo mkdir -p /etc/stunnel/bazarr
sudo openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /etc/stunnel/bazarr/key.pem -out /etc/stunnel/bazarr/cert.pem &> /dev/null
sudo chown -R stunnel:stunnel /etc/stunnel/bazarr
sudo chmod 0755 /etc/stunnel/bazarr
sudo chmod 0640 /etc/stunnel/bazarr/*
echo
echo "Enabling HTTPS..."
sudo bash -c "cat > /etc/stunnel/stunnel.conf << EOF
; **************************************************************************
; * Global options                                                         *
; **************************************************************************

; It is recommended to drop root privileges if stunnel is started by root
setuid = stunnel
setgid = stunnel

; **************************************************************************
; * Service definitions (remove all services for inetd mode)               *
; **************************************************************************

[bazarr-https]
client = no
accept = 0.0.0.0:6767
connect = 127.0.0.1:7676
cert = /etc/stunnel/bazarr/cert.pem
key = /etc/stunnel/bazarr/key.pem
EOF
"
sudo systemctl enable --now stunnel &> /dev/null
echo
echo "Configuring web interface..."
sudo sed -i '/\[general\]/,/^$/{/ip = 0.0.0.0/s/0.0.0.0/127.0.0.1/;/port = 6767/s/6767/7676/}' /var/lib/bazarr/config/config.ini
echo
echo "Disabling Analytics..."
sudo sh -c "if grep -A1 '\[analytics\]' /var/lib/bazarr/config/config.ini | grep -q 'enabled = True'; then
  sed -i '/\[analytics\]/,/^$/{/enabled = True/s/True/False/}' /var/lib/bazarr/config/config.ini
fi"
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
sudo systemctl start $var_service_name
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
sudo systemctl status $var_service_name
