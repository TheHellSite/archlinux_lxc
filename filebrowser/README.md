# File Browser Arch Linux installation (run as root user inside the LXC)

### 1. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/filebrowser/filebrowser_installer.sh)
  ```

<br />
<br />
<br />
<br />
<hr>

# File Browser Arch Linux installation (run as root user inside the LXC)

### 1. Perform a full system upgrade and reboot the LXC.

  ```
  pacman -Syy --noconfirm archlinux-keyring && pacman -Su && reboot
  ```

### 2. Run the command inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/filebrowser/get/master/get.sh)
  ```
