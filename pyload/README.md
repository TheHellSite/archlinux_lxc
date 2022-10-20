# pyLoad Arch Linux installation (run as root user inside the LXC)

### 1. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/pyload/pyload_installer.sh)
  ```

<br />
<br />
<br />
<br />
<hr>

# pyLoad Arch Linux update installation (run as root user inside the LXC)

### 1. Perform a full system upgrade and reboot the LXC.

  ```
  pacman -Syy --noconfirm archlinux-keyring && pacman -Su && reboot
  ```

### 2. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/pyload/pyload_updater.sh)
  ```
