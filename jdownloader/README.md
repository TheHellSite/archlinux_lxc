# JDownloader-headless Arch Linux installation (run as root user inside the LXC)

### 1. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/jdownloader/jdownloader_installer.sh)
  ```

<br />
<br />
<br />
<br />
<hr>

# JDownloader-headless Arch Linux update installation (run as root user inside the LXC)

### 1. Perform a full system upgrade and reboot the LXC.

  ```
  pacman -Syy --noconfirm archlinux-keyring && pacman -Su && reboot
  ```
