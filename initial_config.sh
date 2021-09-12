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
read -p "Press ENTER to continue..."
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
read -p "Press ENTER to continue..."
echo
echo
echo

echo "Configuring Pacman..."
echo "====================="
read -p "Press ENTER to start..."
echo
echo "Enter a Pacman mirror URL."
echo '!!! Only the URL, without "Server = " !!!'
echo 'Example mirror URL: https://mirror.domain.com/archlinux/$repo/os/$arch'
echo "Latest mirrors: https://archlinux.org/mirrorlist/all/https/"
echo
read mirror_url
echo "Server = $mirror_url" >| /etc/pacman.d/mirrorlist
echo 'Disabling extraction of "mirrorlist.pacnew"...'
sed -i 's_#NoExtract   =_NoExtract   = etc/pacman.d/mirrorlist_' /etc/pacman.conf
echo 
echo "Initializing, populating and updating keyring..."
echo
pacman-key --init
pacman-key --populate archlinux
pacman -Syy archlinux-keyring --noconfirm
echo
read -p "Press ENTER to continue..."
echo
echo
echo

echo "Updating system"
echo "==============="
read -p "Press ENTER to start..."
echo
pacman -Syyu --noconfirm
echo
read -p "Press ENTER to continue..."
echo
echo
echo

echo "Refreshing Pacman keys"
echo "======================"
read -p "Press ENTER to start..."
echo
pacman-key --refresh-keys
echo
read -p "Press ENTER to continue..."
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
read -p "Press ENTER to continue..."
echo
echo
echo

echo "======================="
echo "= Rebooting system... ="
echo "======================="
read -p "Press ENTER to reboot"
reboot
