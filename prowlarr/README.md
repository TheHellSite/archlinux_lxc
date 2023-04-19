# Prowlarr Arch Linux installation (run as non-root user inside the LXC)

### 1. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/prowlarr/prowlarr_installer.sh)
  ```

<br />
<br />
<br />
<br />
<hr>

# Prowlarr Arch Linux update installation (run as non-root user inside the LXC)

### 1. Perform a full system upgrade and reboot the LXC.

  ```
  sudo pacman -Syy --noconfirm archlinux-keyring && sudo pacman -Su && sudo reboot
  ```

### 2. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/prowlarr/prowlarr_updater.sh)
  ```
