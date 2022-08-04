# grocy Arch Linux installation (run as root user inside the LXC)

### 1. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/grocy/grocy_installer.sh)
  ```

<br />
<br />
<br />
<br />
<hr>

# grocy Arch Linux update installation (run as root user inside the LXC)

### 1. Perform a full system upgrade and reboot the LXC.

  ```
  pacman -Syy --noconfirm archlinux-keyring && pacman -Su && reboot
  ```

### 2. Run the command inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/grocy/grocy_updater.sh)
  ```
