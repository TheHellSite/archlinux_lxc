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
var_timezone="$(curl -s --fail https://ipapi.co/timezone)"
if [ $? -eq 0 ]; then
  echo "Detected timezone: $var_timezone"
  echo
  echo "Configuring timezone..."
  timedatectl set-timezone "$(curl -s --fail https://ipapi.co/timezone)"
else
  echo "Failed to retrieve timezone."
fi
date
echo
echo
echo
echo

echo "Configuring locales..."
echo "======================"
echo
# Set en_US as the default locale
var_locale_default="en_US.UTF-8"
echo "You now have the option to configure a custom locale or use the default ($var_locale_default) as your locale."
echo "Note: The locale settings can always be changed again at a later time."
echo
while true; do
  read -p "Would you like to configure a custom locale? [no]: " -r
#  echo
  # Set default value for REPLY to "no"
  REPLY=${REPLY:-"no"}
  if [[ "${REPLY,,}" == "y" || "${REPLY,,}" == "yes" ]]; then
    # Extract all available locales that end with UTF-8
    var_locales_available=($(grep -oP '^[^#]*?\.UTF-8' /usr/share/i18n/SUPPORTED))
    # Add all available locales to a selection menu
    PS3=$'\n'"Please input the number of your desired locale: "
    select var_locale_selected in "${var_locales_available[@]}"; do
      if [[ " ${var_locales_available[@]} " =~ " ${var_locale_selected} " ]]; then
        echo
        echo "Selected Locale: ${var_locale_selected}"
        echo
        echo "LC_ALL=${var_locale_selected}" > /etc/environment
        echo "${var_locale_selected} UTF-8" > /etc/locale.gen
        echo "LANG=${var_locale_selected}" > /etc/locale.conf
        locale-gen
        break
      else
        echo "Invalid selection. Please try again."
        echo "To display the list of locales again leave the input blank and press ENTER."
      fi
    done
    break
  elif [[ "${REPLY,,}" == "n" || "${REPLY,,}" == "no" ]]; then
    echo "The default ($var_locale_default) will be used."
    var_locale_selected="$var_locale_default"
    echo
    echo "LC_ALL=${var_locale_selected}" > /etc/environment
    echo "${var_locale_selected} UTF-8" > /etc/locale.gen
    echo "LANG=${var_locale_selected}" > /etc/locale.conf
    locale-gen
    break
  else
    echo 'Invalid input. Please enter "yes" or "no".'
    echo
  fi
done
echo
echo
echo
echo

echo "Configuring Pacman..."
echo "====================="
read -p "Press ENTER to continue..."
echo
echo 'Getting latest mirrors from "https://archlinux.org/mirrorlist/all/https/"...'
curl -s 'https://archlinux.org/mirrorlist/all/https/' | sed -n '/^## Worldwide$/,/^$/p' | sed '/^$/d' | sed 's/^#Server/Server/' >| /etc/pacman.d/mirrorlist
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

echo "Create non-root user"
echo "===================="
echo 'You can now create a non-root user that is a member of group "wheel", thereby granting them "sudo" privileges.'
echo "This is essential if you intend to install packages from the Arch User Repository (AUR)."
echo
while true; do
  read -p "Would you like to create a non-root user? [no]: " -r
  # Set default value for REPLY to "no"
  REPLY=${REPLY:-"no"}
  if [[ "${REPLY,,}" == "y" || "${REPLY,,}" == "yes" ]]; then
    echo
    var_username_default="aur"
    read -p "Enter username [$var_username_default]: " var_username_input
    var_username=${var_username_input:-$var_username_default}
    while ! [[ "$var_username" =~ ^[a-zA-Z0-9_]+$ ]]; do
      echo "Invalid username. Only upper-/lowercase letters, numbers, and underscores are allowed."
      echo
      read -p "Enter username [$var_username_default]: " var_username_input
      var_username=${var_username_input:-$var_username_default}
    done
    while true; do
      read -s -p "Enter password: " var_password
      echo
      read -s -p "Retype password: " var_password_retype
      echo
      if [[ "$var_password" == "$var_password_retype" ]]; then
        break
      else
        echo "Passwords do not match. Please try again."
      fi
    done
    echo
    echo "Creating non-root user \"$var_username\" as a member of group \"wheel\"..."
    useradd -m -g users -G wheel -s /bin/bash "$var_username"
    echo "$var_username:$var_password" | chpasswd
    echo
    echo 'Installing "sudo"...'
    pacman -S --needed --noconfirm sudo
    echo 'Allowing members of group "wheel" to use "sudo"...'
    sed -i 's@^# %wheel ALL=(ALL:ALL) ALL@%wheel ALL=(ALL:ALL) ALL@' /etc/sudoers
    sed -i 's@^# %wheel ALL=(ALL) ALL@%wheel ALL=(ALL) ALL@' /etc/sudoers
    break
  elif [[ "${REPLY,,}" == "n" || "${REPLY,,}" == "no" ]]; then
    echo
    echo "A non-root user will not be created."
    break
  else
    echo 'Invalid input. Please enter "yes" or "no".'
    echo
  fi
done
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
