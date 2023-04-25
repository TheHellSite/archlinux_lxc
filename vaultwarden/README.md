# Vaultwarden Arch Linux installation (run as root user inside the LXC)

### 1. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/vaultwarden/vaultwarden_installer.sh)
  ```

<br />
<br />
<br />
<br />
<hr>

# Vaultwarden Arch Linux update installation (run as root user inside the LXC)

### 1. Perform a full system maintenance and reboot the LXC.

  ```
  pacman -Sy --noconfirm archlinux-keyring && pacman -Su && pacman -Qtdq | pacman -Rns --noconfirm - 2> >(grep -v "error: argument '-' specified with empty stdin" >&2); yes | pacman -Scc; reboot
  ```
