# !!! DO NOT USE !!! WORK IN PROGRESS !!!

# Grocy Arch Linux installation (run as non-root user inside the LXC)

### 1. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/grocy/grocy_installer.sh)
  ```

<br />
<br />
<br />
<br />
<hr>

# Grocy Arch Linux update installation (run as non-root user inside the LXC)

### 1. Perform a full system upgrade and reboot the LXC.

  ```
  sudo pacman -Syyu && sudo reboot
  ```

### 2. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/grocy/grocy_updater.sh)
  ```
