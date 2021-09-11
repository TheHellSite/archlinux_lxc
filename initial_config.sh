#!/bin/bash

###################
# start of script #
###################
clear
echo
echo
echo
echo "This script will perform the inital configuration of an Arch Linux LXC."
read -p "Press ENTER to start the script."
echo
echo
echo
echo "Setting timezone..."
echo "==================="
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
date
echo
read -p "Press ENTER to continue..."
echo
echo
echo

echo "Configuring locales..."
echo "======================"
echo 'LC_ALL=de_DE.UTF-8' >| /etc/environment
echo 'de_DE.UTF-8 UTF-8' >| /etc/locale.gen
echo 'LANG=de_DE.UTF-8' >| /etc/locale.conf
locale-gen
echo
read -p "Press ENTER to continue..."
echo
echo
echo

echo "Updating and configuring mirrorlist..."
echo "======================================"
echo "Provide Pacman mirror URL."
echo '!!! Only the URL, without "Server = " !!!'
echo 'Example mirror URL: https://mirror.domain.com/archlinux/$repo/os/$arch'
echo "Latest mirrors: https://archlinux.org/mirrorlist/all/https/"
read mirror_url
echo "Server = $mirror_url" >| /etc/pacman.d/mirrorlist
pacman-key --init
pacman-key --populate archlinux
trust extract-compat
pacman -Syy archlinux-keyring --noconfirm
pacman-key --refresh-keys
echo
read -p "Press ENTER to continue..."
echo
echo
echo


echo "Updating system..."
echo "=================="
pacman -Syyu
echo
read -p "Press ENTER to continue..."
echo
echo
echo


echo "======================="
echo "= Rebooting system... ="
echo "======================="
echo
read -p "Press ENTER to reboot"
reboot

#################
# end of script #
#################
