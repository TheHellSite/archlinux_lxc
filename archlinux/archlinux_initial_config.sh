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
read -p "Press ENTER to continue..."
echo
timedatectl set-timezone "$(curl -s --fail https://ipapi.co/timezone)"
echo
date
echo
echo
echo
echo

echo "Configuring locales..."
echo "======================"
read -p "Press ENTER to continue..."
echo
echo 'LC_ALL=en_US.UTF-8' >| /etc/environment
echo 'en_US.UTF-8 UTF-8' >| /etc/locale.gen
echo 'LANG=en_US.UTF-8' >| /etc/locale.conf
locale-gen
echo
echo
echo
echo

echo "Configuring Pacman..."
echo "====================="
read -p "Press ENTER to continue..."
echo
echo "Getting latest mirrors from: https://archlinux.org/mirrorlist/all/https/"
echo
var_mirrorlist=$(curl -s 'https://archlinux.org/mirrorlist/all/https/' | sed -n '/^## Worldwide$/,/^$/p' | sed '/^$/d' | sed 's/^#Server/Server/')
echo "$var_mirrorlist" >| /etc/pacman.d/mirrorlist
echo
echo 'Disabling extraction of "mirrorlist.pacnew"...'
sed -i 's@^#NoExtract   =@NoExtract   = etc/pacman.conf etc/pacman.d/mirrorlist@' /etc/pacman.conf
echo 
echo "Initializing, populating and updating keyring..."
echo
pacman-key --init
pacman-key --populate archlinux
pacman -Syy --noconfirm archlinux-keyring
echo
echo
echo
echo

echo "Updating system"
echo "==============="
read -p "Press ENTER to continue..."
echo
pacman -Syyu --noconfirm
echo
echo
echo
echo

echo "Configuring Pacman Reflector"
echo "============================"
read -p "Press ENTER to continue..."
echo
pacman -S --needed --noconfirm reflector
echo
reflector --list-countries
echo
echo "Select the country closest to your location from the list above."
echo "Enter the two-letter country code below."
echo
read -p 'Country: ' reflector_country
echo
echo "" > /etc/xdg/reflector/reflector.conf
echo "--age 12" >> /etc/xdg/reflector/reflector.conf
echo "--country $reflector_country" >> /etc/xdg/reflector/reflector.conf
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

echo "Rebooting system..."
echo "==================="
echo "The initial configuration of your Arch Linux LXC is complete."
echo
read -p "Press ENTER to reboot"
reboot
