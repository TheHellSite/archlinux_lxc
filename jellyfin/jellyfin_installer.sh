#!/bin/bash

# begin of variables
var_service_name="jellyfin"
var_service_friendly_name="Jellyfin"
var_service_friendly_name_length="========"
var_service_default_port="8920"
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

echo "Installing $var_service_friendly_name..."
echo "===========$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo "Installing $var_service_friendly_name..."
pacman -Syu --needed --noconfirm jellyfin-server jellyfin-web jellyfin-ffmpeg
echo
echo
echo
echo

echo "Configuring $var_service_friendly_name..."
echo "============$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo "Configuring systemd overrides (Restart, RestartSec, LimitCORE) for jellyfin..."
mkdir -p /etc/systemd/system/jellyfin.service.d
cat > /etc/systemd/system/jellyfin.service.d/override.conf << EOF
[Service]
Restart=always
RestartSec=5s
LimitCORE=0
EOF
systemctl daemon-reload
echo
echo "Enabling and starting $var_service_friendly_name to generate config files..."
systemctl enable --now $var_service_name &> /dev/null
echo
echo "Waiting 10 seconds for $var_service_friendly_name to start..."
sleep 10
echo
echo "Stopping $var_service_friendly_name to edit config files..."
systemctl stop $var_service_name
echo
# START TEMPORARY INCLUDED (until fixed upstream)
# if not exist create network.xml
echo "Generating network config..."
if [ ! -e "/etc/jellyfin/network.xml" ]; then
  cat > /etc/jellyfin/network.xml << EOF
<NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <RequireHttps>false</RequireHttps>
  <CertificatePath />
  <CertificatePassword />
  <BaseUrl />
  <PublicHttpsPort>8920</PublicHttpsPort>
  <HttpServerPortNumber>8096</HttpServerPortNumber>
  <HttpsPortNumber>8920</HttpsPortNumber>
  <EnableHttps>false</EnableHttps>
  <PublicPort>8096</PublicPort>
  <UPnPCreateHttpPortMap>false</UPnPCreateHttpPortMap>
  <UDPPortRange />
  <EnableIPV6>false</EnableIPV6>
  <EnableIPV4>true</EnableIPV4>
  <EnableSSDPTracing>false</EnableSSDPTracing>
  <SSDPTracingFilter />
  <UDPSendCount>2</UDPSendCount>
  <UDPSendDelay>100</UDPSendDelay>
  <IgnoreVirtualInterfaces>true</IgnoreVirtualInterfaces>
  <VirtualInterfaceNames>vEthernet*</VirtualInterfaceNames>
  <GatewayMonitorPeriod>60</GatewayMonitorPeriod>
  <TrustAllIP6Interfaces>false</TrustAllIP6Interfaces>
  <HDHomerunPortRange />
  <PublishedServerUriBySubnet />
  <AutoDiscoveryTracing>false</AutoDiscoveryTracing>
  <AutoDiscovery>true</AutoDiscovery>
  <RemoteIPFilter />
  <IsRemoteIPFilterBlacklist>false</IsRemoteIPFilterBlacklist>
  <EnableUPnP>false</EnableUPnP>
  <EnableRemoteAccess>true</EnableRemoteAccess>
  <LocalNetworkSubnets />
  <LocalNetworkAddresses />
  <KnownProxies />
  <EnablePublishedServerUriByRequest>false</EnablePublishedServerUriByRequest>
</NetworkConfiguration>
EOF
chown jellyfin:jellyfin /etc/jellyfin/network.xml
fi
echo
# END TEMPORARY INCLUDED (until fixed upstream)
echo "Generating self-signed SSL certificate..."
mkdir -p /etc/jellyfin/ssl
openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout /etc/jellyfin/ssl/key.pem -out /etc/jellyfin/ssl/cert.pem &> /dev/null
openssl pkcs12 -export -inkey /etc/jellyfin/ssl/key.pem -in /etc/jellyfin/ssl/cert.pem -out /etc/jellyfin/ssl/cert.pfx -passout pass:
rm /etc/jellyfin/ssl/*.pem
chown -R jellyfin:jellyfin /etc/jellyfin/ssl
chmod 0755 /etc/jellyfin/ssl
chmod 0640 /etc/jellyfin/ssl/*
echo
echo "Enabling HTTPS..."
sed -i 's@<CertificatePath />@<CertificatePath>/etc/jellyfin/ssl/cert.pfx</CertificatePath>@' /etc/jellyfin/network.xml
sed -i 's@<EnableHttps>false</EnableHttps>@<EnableHttps>true</EnableHttps>@' /etc/jellyfin/network.xml
sed -i 's@<RequireHttps>false</RequireHttps>@<RequireHttps>true</RequireHttps>@' /etc/jellyfin/network.xml
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
