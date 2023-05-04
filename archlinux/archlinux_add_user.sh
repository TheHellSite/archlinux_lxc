#!/bin/bash

clear
echo "============================="
echo "== Arch Linux LXC add user =="
echo "============================="
echo
echo "This script creates a new non-root user in your Arch Linux LXC."
echo
read -p "Press ENTER to start the script."
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
  read -p "Would you like to create a non-root user? [yes]: " -r
  # Set default value for REPLY to "yes"
  REPLY=${REPLY:-"yes"}
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
    pacman -Syu --needed --noconfirm sudo
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

echo "======================="
echo "= Rebooting system... ="
echo "======================="
read -p "Press ENTER to reboot"
reboot
