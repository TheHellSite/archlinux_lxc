#!/bin/bash

# begin of variables
var_local_ip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
var_menu_options=("Lidarr" "Radarr" "Readarr" "Prowlarr" "Sonarr" "Whisparr")
# end of variables

# begin of functions
# set service variables based on selection
func_set_service_variables() {
  case $1 in
    1)
      var_service_dependencies="chromaprint jack2 mediainfo sqlite3"
      var_service_download_url="https://lidarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64"
      var_service_friendly_name="Lidarr"
      var_service_name=${var_service_friendly_name,,}
      var_service_friendly_name_length=${var_service_friendly_name//?/=}
      var_service_default_http_port="8686"
      var_service_default_https_port="6868"
      ;;
    2)
      var_service_dependencies="sqlite3"
      var_service_download_url="https://radarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64"
      var_service_friendly_name="Radarr"
      var_service_name=${var_service_friendly_name,,}
      var_service_friendly_name_length=${var_service_friendly_name//?/=}
      var_service_default_http_port="7878"
      var_service_default_https_port="9898"
      ;;
    3)
      var_service_dependencies="sqlite3"
      var_service_download_url="https://readarr.servarr.com/v1/update/develop/updatefile?os=linux&runtime=netcore&arch=x64"
      var_service_friendly_name="Readarr"
      var_service_name=${var_service_friendly_name,,}
      var_service_friendly_name_length=${var_service_friendly_name//?/=}
      var_service_default_http_port="8787"
      var_service_default_https_port="6868"
      ;;
    4)
      var_service_dependencies="sqlite3"
      var_service_download_url="https://prowlarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64"
      var_service_friendly_name="Prowlarr"
      var_service_name=${var_service_friendly_name,,}
      var_service_friendly_name_length=${var_service_friendly_name//?/=}
      var_service_default_http_port="9696"
      var_service_default_https_port="6969"
      ;;
    5)
      var_service_dependencies="sqlite3"
      var_service_download_url="https://services.sonarr.tv/v1/download/main/latest?version=4&os=linux&arch=x64"
      var_service_friendly_name="Sonarr"
      var_service_name=${var_service_friendly_name,,}
      var_service_friendly_name_length=${var_service_friendly_name//?/=}
      var_service_default_http_port="8989"
      var_service_default_https_port="9898"
      ;;
    6)
      var_service_dependencies="sqlite3"
      var_service_download_url="https://whisparr.servarr.com/v1/update/nightly/updatefile?os=linux&runtime=netcore&arch=x64"
      var_service_friendly_name="Whisparr"
      var_service_name=${var_service_friendly_name,,}
      var_service_friendly_name_length=${var_service_friendly_name//?/=}
      var_service_default_http_port="6969"
      var_service_default_https_port="8008"
      ;;
    *)
      echo "Invalid choice, exiting."
      exit 1
      ;;
  esac
}
# end of functions

clear
echo "==============================================="
echo "== Arch Linux LXC - *arr universal installer =="
echo "==============================================="
echo
echo "This script will install one of the below *arr applications."
echo 
echo "Currently supported applications: Lidarr, Radarr, Readarr, Prowlarr, Sonarr, Whisparr"
echo
read -p "Press ENTER to start the script."
echo
echo
echo
echo

echo "Application selection"
echo "====================="
echo
PS3="
Please select the application to be installed (1-6): "
select opt in "${var_menu_options[@]}"
do
  case $REPLY in
    1|2|3|4|5|6)
      func_set_service_variables $REPLY
      break
      ;;
    *)
      echo "Invalid choice, please select a number between 1 and 6."
      ;;
  esac
done
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
echo "Installing ${var_service_friendly_name}..."
mkdir -p /tmp/${var_service_name}_installer/${var_service_name}
curl -L -o /tmp/${var_service_name}_installer/${var_service_name}_latest_linux.tar.gz "${var_service_download_url}"
tar -xzf /tmp/${var_service_name}_installer/${var_service_name}_latest_linux.tar.gz --strip-components=1 -C /tmp/${var_service_name}_installer/${var_service_name}
mv /tmp/${var_service_name}_installer/${var_service_name} /opt/${var_service_name}
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
ExecStart=/opt/${var_service_name}/${var_service_friendly_name} -nobrowser -data=/var/lib/${var_service_name}
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
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /var/lib/${var_service_name}/ssl/key.pem -out /var/lib/${var_service_name}/ssl/cert.pem &> /dev/null
openssl pkcs12 -export -inkey /var/lib/${var_service_name}/ssl/key.pem -in /var/lib/${var_service_name}/ssl/cert.pem -out /var/lib/${var_service_name}/ssl/cert.pfx -passout pass:
rm /var/lib/${var_service_name}/ssl/*.pem
chown -R ${var_service_name}:${var_service_name} /var/lib/${var_service_name}/ssl
chmod 0755 /var/lib/${var_service_name}/ssl
chmod 0640 /var/lib/${var_service_name}/ssl/*
echo
echo "Enabling HTTPS..."
sed -i 's@<EnableSsl>False</EnableSsl>@<EnableSsl>True</EnableSsl>@' /var/lib/${var_service_name}/config.xml
sed -i "s@<SslCertPath></SslCertPath>@<SslCertPath>/var/lib/${var_service_name}/ssl/cert.pfx</SslCertPath>@" /var/lib/${var_service_name}/config.xml
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
echo "http://${var_local_ip}:${var_service_default_http_port}"
echo "https://${var_local_ip}:${var_service_default_https_port}"
echo
echo "Proceed to display the service status and end the script."
echo
read -p "Press ENTER to continue..."
echo
systemctl status ${var_service_name}
