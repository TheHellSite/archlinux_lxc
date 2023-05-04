# Syncthing Arch Linux installation (run as root user inside the LXC)

### 1. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/syncthing/syncthing_installer.sh)
  ```

<br />
<br />
<br />
<br />
<hr>

# Syncthing Arch Linux update installation (run as root user inside the LXC)

### 1. Perform a full system maintenance and reboot the LXC.

  ```
  pacman -Sy --noconfirm archlinux-keyring && pacman -Su --noconfirm && if pacman -Qtdq >/dev/null; then pacman -Rns --noconfirm $(pacman -Qtdq); fi && yes | pacman -Scc && reboot
  ```
