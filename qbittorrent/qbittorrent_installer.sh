#!/bin/bash

# begin of variables
var_local_ip=$(ip route get 1.1.1.1 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
var_service_name="qbittorrent"
var_service_username="qbt"
var_service_friendly_name="qBittorrent-nox"
var_service_friendly_name_length=${var_service_friendly_name//?/=}
var_service_default_port="8080"
var_service_dependencies="python qbittorrent-nox"
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
echo "Creating service \"${var_service_name}\"..."
cat > /etc/systemd/system/${var_service_name}.service << EOF
[Unit]
Description=${var_service_friendly_name}
After=network.target

[Service]
Type=simple
User=${var_service_username}
Group=${var_service_username}
ExecStart=/usr/bin/qbittorrent-nox
Restart=always
RestartSec=5s
TimeoutSec=20

[Install]
WantedBy=multi-user.target
EOF
echo
echo "Enabling and starting ${var_service_friendly_name} to generate config files..."
chown -R ${var_service_username}:${var_service_username} /var/lib/${var_service_name}
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
chown -R ${var_service_username}:${var_service_username} /var/lib/${var_service_name}/ssl
chmod 0755 /var/lib/${var_service_name}/ssl
chmod 0640 /var/lib/${var_service_name}/ssl/*
echo
echo "Configuring ${var_service_friendly_name}..."
mkdir -p /tmp/torrent
cat > /var/lib/${var_service_name}/.config/qBittorrent/qBittorrent.conf << EOF
[AutoRun]
enabled=false
program=

[BitTorrent]
Session\AddExtensionToIncompleteFiles=true
Session\AlternativeGlobalDLSpeedLimit=512
Session\AlternativeGlobalUPSpeedLimit=512
Session\AnonymousModeEnabled=true
Session\DefaultSavePath=/tmp/torrent
Session\DisableAutoTMMByDefault=false
Session\GlobalUPSpeedLimit=512
Session\IgnoreLimitsOnLAN=true
Session\IgnoreSlowTorrentsForQueueing=true
Session\IncludeOverheadInLimits=false
Session\LSDEnabled=false
Session\MaxActiveDownloads=-1
Session\MaxActiveTorrents=-1
Session\MaxActiveUploads=2
Session\MaxRatioAction=1
Session\Port=40252
Session\Preallocation=true
Session\QueueingSystemEnabled=true
Session\SlowTorrentsDownloadRate=128
Session\TempPath=/tmp/torrent

[Core]
AutoDeleteAddedTorrentFile=Never

[Meta]
MigrationVersion=2

[Network]
Cookies=@Invalid()
PortForwardingEnabled=false
Proxy\OnlyForTorrents=false

[Preferences]
Advanced\RecheckOnCompletion=true
Advanced\trackerPort=9000
Connection\ResolvePeerCountries=true
DynDNS\DomainName=changeme.dyndns.org
DynDNS\Enabled=false
DynDNS\Password=
DynDNS\Service=DynDNS
DynDNS\Username=
General\Locale=en
MailNotification\email=
MailNotification\enabled=false
MailNotification\password=
MailNotification\req_auth=true
MailNotification\req_ssl=false
MailNotification\sender=qBittorrent_notification@example.com
MailNotification\smtp_server=smtp.changeme.com
MailNotification\username=
WebUI\Address=*
WebUI\AlternativeUIEnabled=false
WebUI\AuthSubnetWhitelist=@Invalid()
WebUI\AuthSubnetWhitelistEnabled=false
WebUI\BanDuration=3600
WebUI\CSRFProtection=true
WebUI\ClickjackingProtection=true
WebUI\CustomHTTPHeaders=
WebUI\CustomHTTPHeadersEnabled=false
WebUI\HTTPS\CertificatePath=/var/lib/qbittorrent/ssl/cert.pem
WebUI\HTTPS\Enabled=true
WebUI\HTTPS\KeyPath=/var/lib/qbittorrent/ssl/key.pem
WebUI\HostHeaderValidation=true
WebUI\LocalHostAuth=true
WebUI\MaxAuthenticationFailCount=5
WebUI\Port=8080
WebUI\ReverseProxySupportEnabled=false
WebUI\RootFolder=
WebUI\SecureCookie=true
WebUI\ServerDomains=*
WebUI\SessionTimeout=3600
WebUI\TrustedReverseProxiesList=
WebUI\UseUPnP=false
WebUI\Username=admin

[RSS]
AutoDownloader\DownloadRepacks=true
AutoDownloader\SmartEpisodeFilter=s(\\d+)e(\\d+), (\\d+)x(\\d+), "(\\d{4}[.\\-]\\d{1,2}[.\\-]\\d{1,2})", "(\\d{1,2}[.\\-]\\d{1,2}[.\\-]\\d{4})"
EOF
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
echo "https://${var_local_ip}:${var_service_default_port}"
echo
echo "Proceed to display the service status and end the script."
echo
read -p "Press ENTER to continue..."
echo
systemctl status ${var_service_name}
