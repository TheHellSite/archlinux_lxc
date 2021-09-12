#!/bin/bash

clear
echo "=========================================="
echo "== Arch Linux LXC initial configuration =="
echo "=========================================="
echo
echo "This script will perform the inital"
echo "configuration of an Arch Linux LXC."
echo
read -p "Press ENTER to start the script."
echo
echo
echo

echo "Setting timezone..."
echo "==================="
read -p "Press ENTER to start..."
echo
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
date
echo
echo
echo
echo

echo "Configuring locales..."
echo "======================"
read -p "Press ENTER to start..."
echo
echo 'LC_ALL=en_GB.UTF-8' >| /etc/environment
echo 'en_GB.UTF-8 UTF-8' >| /etc/locale.gen
echo 'LANG=en_GB.UTF-8' >| /etc/locale.conf
locale-gen
echo
echo
echo
echo

echo "Configuring Pacman..."
echo "====================="
read -p "Press ENTER to start..."
echo
echo "Enter an up-to-date Pacman mirror URL."
echo 'For example: "Server = https://mirror.domain.com/archlinux/$repo/os/$arch"'
echo "Latest mirrors are available here: https://archlinux.org/mirrorlist/all/https/"
echo
read -p 'Mirror URL: ' mirror_url_var
echo "$mirror_url_var" >| /etc/pacman.d/mirrorlist
echo
echo 'Disabling extraction of "mirrorlist.pacnew"...'
sed -i 's_#NoExtract   =_NoExtract   = etc/pacman.d/mirrorlist etc/pacman.conf_' /etc/pacman.conf
echo 
echo "Initializing, populating and updating keyring..."
echo
pacman-key --init
pacman-key --populate archlinux
pacman -Syy archlinux-keyring --noconfirm
echo
echo
echo
echo

echo "Updating system"
echo "==============="
read -p "Press ENTER to start..."
echo
pacman -Syyu --noconfirm
echo
echo
echo
echo

echo "Refreshing Pacman keys"
echo "======================"
read -p "Press ENTER to start..."
echo
pacman-key --refresh-keys
echo
echo
echo
echo

echo "Configuring Pacman Reflector"
echo "============================"
read -p "Press ENTER to start..."
echo
pacman -S reflector --noconfirm
echo "" > /etc/xdg/reflector/reflector.conf
echo "--age 12" >> /etc/xdg/reflector/reflector.conf
echo "--country Germany" >> /etc/xdg/reflector/reflector.conf
echo "--latest 10" >> /etc/xdg/reflector/reflector.conf
echo "--protocol https" >> /etc/xdg/reflector/reflector.conf
echo "--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf
echo "--sort rate" >> /etc/xdg/reflector/reflector.conf
systemctl enable reflector.timer
echo "Generating new mirrorlist using Reflector..."
systemctl restart reflector.service
echo
cat /etc/pacman.d/mirrorlist
echo
echo
echo
echo

echo "Adding new user"
echo "==============="
read -p "Press ENTER to start..."
echo
echo 'Installing "sudo"...'
pacman -S sudo --noconfirm
echo 'Allowing members of group "wheel" to use "sudo"...'
sed -i 's_# %wheel ALL=(ALL) ALL_%wheel ALL=(ALL) ALL_' /etc/sudoers
echo
echo 'Creating new user that is a member of group "wheel"...'
read -p 'Username: ' username_var
read -p 'Password: ' password_var
#useradd -m -G wheel -s /bin/bash $username_var
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
