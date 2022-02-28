#!/bin/bash

clear
echo "============================="
echo "== Arch Linux LXC add user =="
echo "============================="
echo
echo "This script adds a new user"
echo "to your Arch Linux LXC and"
echo "adds it to group wheel."
echo
read -p "Press ENTER to start the script."
echo
echo
echo
echo

echo "Adding new user"
echo "==============="
read -p "Press ENTER to continue..."
echo
echo 'Installing "sudo"...'
pacman -Syyu --needed --noconfirm sudo
echo 'Allowing members of group "wheel" to use "sudo"...'
sed -i 's@^# %wheel ALL=(ALL:ALL) ALL@%wheel ALL=(ALL:ALL) ALL' /etc/sudoers
sed -i 's@^# %wheel ALL=(ALL) ALL@%wheel ALL=(ALL) ALL@' /etc/sudoers
echo
echo 'Creating new user that is a member of group "wheel"...'
read -p 'Username: ' username_var
read -s -p 'Password: ' password_var
useradd -m -g users -G wheel -s /bin/bash $username_var
echo "$username_var:$password_var" | chpasswd
echo
echo
echo
echo

echo "======================="
echo "= Rebooting system... ="
echo "======================="
read -p "Press ENTER to reboot"
reboot
