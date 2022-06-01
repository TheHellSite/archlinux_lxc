#!/bin/bash

# begin of variables
var_service_name="nginx php-fpm"
var_service_friendly_name="grocy"
var_service_friendly_name_length="====="
var_local_ip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
# end of variables

clear
echo "====================$var_service_friendly_name_length==========="
echo "== Arch Linux LXC - $var_service_friendly_name Updater =="
echo "====================$var_service_friendly_name_length==========="
echo
echo "This script will update $var_service_friendly_name."
echo
read -p "Press ENTER to start the script."
echo
echo
echo
echo

echo "Updating $var_service_friendly_name..."
echo "=========$var_service_friendly_name_length==="
read -p "Press ENTER to continue..."
echo
echo "Stopping web server..."
systemctl stop $var_service_name
echo
echo "Updating $var_service_friendly_name..."
chmod +x /var/lib/grocy/update.sh
/var/lib/grocy/update.sh &> /dev/null
echo
echo
echo
echo

echo "Restarting $var_service_friendly_name..."
echo "===========$var_service_friendly_name_length==="
echo "The $var_service_friendly_name update is complete."
echo "Proceed to start $var_service_friendly_name and display the service status."
echo
read -p "Press ENTER to continue..."
echo
systemctl start $var_service_name
echo "Waiting 5 seconds for $var_service_friendly_name to start..."
sleep 5
echo
sudo systemctl status $var_service_name
