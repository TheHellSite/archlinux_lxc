# qBittorrent-nox Arch Linux installation (run as root user inside the LXC)

### 1. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/qbittorrent/qbittorrent_installer.sh)
  ```

<br />
<br />
<br />
<br />
<hr>

# qBittorrent-nox Arch Linux update installation (run as root user inside the LXC)

  ```
  pacman -Syy --noconfirm archlinux-keyring && pacman -Su && reboot
  ```
