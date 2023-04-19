#!/bin/bash

# begin of variables
var_service_name="prowlarr"
var_service_friendly_name="Prowlarr"
var_service_friendly_name_length="======"
var_service_default_port="6969"
var_local_ip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
var_local_subnet=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}' | sed 's@[^.]*$@0/24@')
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
sudo pacman -Syyu --needed --noconfirm git base-devel
echo
echo
echo
echo

echo "Installing $var_service_friendly_name..."
echo "===========$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
git clone https://aur.archlinux.org/prowlarr.git
cd prowlarr
makepkg -sirc --noconfirm
cd
sudo rm -r prowlarr
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
sudo mkdir -p /var/lib/prowlarr/ssl
sudo openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/prowlarr/ssl/key.pem -out /var/lib/prowlarr/ssl/cert.pem &> /dev/null
sudo openssl pkcs12 -export -inkey /var/lib/prowlarr/ssl/key.pem -in /var/lib/prowlarr/ssl/cert.pem -out /var/lib/prowlarr/ssl/cert.pfx -passout pass:
sudo rm /var/lib/prowlarr/ssl/*.pem
sudo chown -R prowlarr:prowlarr /var/lib/prowlarr/ssl
sudo chmod 0755 /var/lib/prowlarr/ssl
sudo chmod 0640 /var/lib/prowlarr/ssl/*
echo
echo "Enabling HTTPS..."
sudo sed -i 's@<EnableSsl>False<\/EnableSsl>@<EnableSsl>True<\/EnableSsl>@' /var/lib/prowlarr/config.xml
sudo sed -i 's@<SslCertPath></SslCertPath>@<SslCertPath>/var/lib/prowlarr/ssl/cert.pfx<\/SslCertPath>@' /var/lib/prowlarr/config.xml
echo
echo "Disabling Analytics..."
if grep -q '<AnalyticsEnabled>' /var/lib/prowlarr/config.xml; then
  if grep -q '<AnalyticsEnabled>True</AnalyticsEnabled>' /var/lib/prowlarr/config.xml; then
    sudo sed -i 's@<AnalyticsEnabled>True</AnalyticsEnabled>@<AnalyticsEnabled>False</AnalyticsEnabled>@' /var/lib/prowlarr/config.xml
  fi
else
  sudo sed -i '\@</Config>@i \  <AnalyticsEnabled>False</AnalyticsEnabled>' /var/lib/prowlarr/config.xml
fi
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
