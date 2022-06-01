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
echo "Enabling dependencies..."
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
echo "Configuring web server..."
cat > /etc/nginx/nginx.conf << 'EOF'
user                 http;
worker_processes     auto;
worker_rlimit_nofile 65535;

events {
    multi_accept       on;
    worker_connections 65535;
}

http {
    charset                utf-8;
    sendfile               on;
    tcp_nopush             on;
    tcp_nodelay            on;
    server_tokens          off;
    log_not_found          off;
    types_hash_max_size    4096;
    types_hash_bucket_size 64;
    client_max_body_size   16M;

    # MIME
    include                mime.types;
    default_type           application/octet-stream;

    # Logging
    access_log             /var/log/nginx/access.log;
    error_log              /var/log/nginx/error.log warn;

    # SSL
    ssl_session_timeout    1d;
    ssl_session_cache      shared:SSL:10m;
    ssl_session_tickets    off;

    # Mozilla Modern configuration
    ssl_protocols          TLSv1.3;

    # Grocy server
    server {
        listen                             80;
        listen                             443 ssl http2;
        server_name                        _;
        set                                $base /var/lib/grocy;
        root                               $base/public;

        # SSL
        ssl_certificate                    /etc/nginx/ssl/cert.pem;
        ssl_certificate_key                /etc/nginx/ssl/key.pem;

        # security headers
        add_header X-XSS-Protection        "1; mode=block" always;
        add_header X-Content-Type-Options  "nosniff" always;
        add_header Referrer-Policy         "no-referrer-when-downgrade" always;
        add_header Content-Security-Policy "default-src 'self' http: https: ws: wss: data: blob: 'unsafe-inline'; frame-ancestors 'self';" always;
        add_header Permissions-Policy      "interest-cohort=()" always;

        # . files
        location ~ /\. {
            deny all;
        }

        # index.php
        index index.php;

        # index.php fallback
        location / {
            try_files $uri $uri/ /index.php?$query_string;
        }

        # favicon.ico
        location = /favicon.ico {
            log_not_found off;
            access_log    off;
        }

        # robots.txt
        location = /robots.txt {
            log_not_found off;
            access_log    off;
        }

        # assets, media
        location ~* \.(?:css(\.map)?|js(\.map)?|jpe?g|png|gif|ico|cur|heic|webp|tiff?|mp3|m4a|aac|ogg|midi?|wav|mp4|mov|webm|mpe?g|avi|ogv|flv|wmv)$ {
            expires    7d;
            access_log off;
        }

        # svg, fonts
        location ~* \.(?:svgz?|ttf|ttc|otf|eot|woff2?)$ {
            add_header Access-Control-Allow-Origin "*";
            expires    7d;
            access_log off;
        }

        # gzip
        gzip            on;
        gzip_vary       on;
        gzip_proxied    any;
        gzip_comp_level 6;
        gzip_types      text/plain text/css text/xml application/json application/javascript application/rss+xml application/atom+xml image/svg+xml;

        # handle .php
        location ~ \.php$ {
            fastcgi_pass                  unix:/run/php-fpm/php-fpm.sock;

            # 404
            try_files                     $fastcgi_script_name =404;

            # default fastcgi_params
            include                       fastcgi_params;

            # fastcgi settings
            fastcgi_index                 index.php;
            fastcgi_buffers               8 16k;
            fastcgi_buffer_size           32k;

            # fastcgi params
            fastcgi_param DOCUMENT_ROOT   $realpath_root;
            fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
            fastcgi_param PHP_ADMIN_VALUE "open_basedir=$base/:/usr/lib/php/:/tmp/";
        }
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
echo "https://$var_local_ip"
echo
echo "Proceed to display the service status and end the script."
echo
read -p "Press ENTER to continue..."
echo
systemctl status $var_service_name
