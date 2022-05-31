#!/bin/bash

# begin of variables
var_service_name="nginx php-fpm"
var_service_friendly_name="Grocy"
var_service_friendly_name_length="====="
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

echo "Installing dependencies..."
echo "=========================="
read -p "Press ENTER to continue..."
echo
echo "Installing dependencies..."
pacman -Syyu --needed --noconfirm nginx php-fpm php-gd php-intl php-sqlite sqlite unzip wget
echo
echo
echo
echo

echo "Installing $var_service_friendly_name..."
echo "===========$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo "Downloading $var_service_friendly_name..."
wget https://releases.grocy.info/latest &> /dev/null
echo
echo "Installing $var_service_friendly_name..."
unzip latest -d /var/lib/grocy &> /dev/null
rm latest
cp /var/lib/grocy/config-dist.php /var/lib/grocy/data/config.php
chown -R http:http /var/lib/grocy
echo
echo
echo
echo

echo "Configuring $var_service_friendly_name..."
echo "============$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo "Enabling and starting web server to generate config files..."
systemctl enable --now $var_service_name &> /dev/null
echo
echo "Waiting 10 seconds for web server to start..."
sleep 10
echo
echo "Stopping web server to edit config files..."
systemctl stop $var_service_name
echo
echo "Configuring web server..."
sed -i '/    include       mime.types;/a \
    include       sites-available/*;' /etc/nginx/nginx.conf
sed -i '/    keepalive_timeout  65;/a \
\
    types_hash_max_size 4096;' /etc/nginx/nginx.conf
sed -i 's@;extension=gd@extension=gd@' /etc/php/php.ini
sed -i 's@;extension=iconv@extension=iconv@' /etc/php/php.ini
sed -i 's@;extension=intl@extension=intl@' /etc/php/php.ini
sed -i 's@;extension=pdo_sqlite@extension=pdo_sqlite@' /etc/php/php.ini
sed -i 's@;extension=sqlite3@extension=sqlite3@' /etc/php/php.ini
echo
echo "Generating self-signed SSL certificate..."
mkdir -p /etc/nginx/ssl
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /etc/nginx/ssl/key.pem -out /etc/nginx/ssl/cert.pem &> /dev/null
echo
echo "Configuring Web Interface..."
mkdir -p /etc/nginx/sites-available
cat <<'EOF' >/etc/nginx/sites-available/grocy.conf
# HTTP server (redirects to HTTPS)
server {
    listen 80;
    server_name _;
    return 301 https://$host$request_uri;
    }

# HTTPS server
server {
    listen              443 ssl http2;
    server_name         _;
    ssl_protocols       TLSv1.3;
    ssl_certificate     ssl/cert.pem;
    ssl_certificate_key ssl/key.pem;

    root /var/lib/grocy/public;

    location / {
        try_files $uri /index.php;
    }

    location ~ \.php$ {
        # 404
        try_files $fastcgi_script_name =404;

        # default fastcgi_params
        include fastcgi_params;

        # fastcgi settings
        fastcgi_buffers                 8 16k;
        fastcgi_buffer_size             32k;
        fastcgi_index                   index.php;
        fastcgi_pass                    unix:/run/php-fpm/php-fpm.sock;
        fastcgi_split_path_info         ^(.+?\.php)(|/.*)$;

        # fastcgi params
        fastcgi_param DOCUMENT_ROOT     $realpath_root;
        fastcgi_param SCRIPT_FILENAME   $realpath_root$fastcgi_script_name;
    }
}
EOF
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
