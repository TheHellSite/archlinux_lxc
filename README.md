# Arch Linux LXC initial config script (run as root user)

1. Extract compatibility trust certificate bundles inside of the Arch Linux LXC.

       trust extract-compat

2. Get the script URL with a valid token by visiting: https://github.com/TheHellSite/archlinux_lxc/raw/main/initial_config.sh

3. Run the script inside of the Arch Linux LXC.

       bash <(curl -s URL)


# Jellyfin installation (run as non-root user)

1. Mount NAS share.

       sudo pacman -Syyu cifs-utils --noconfirm
       sudo mkdir /mnt/nas
       echo '//NAS/nas /mnt/nas cifs _netdev,noatime,uid=vod,gid=users,user=SMBUSER,pass=SMBPASSWORD 0 0' | sudo tee -a /etc/fstab
       sudo mount -a && ls /mnt/nas

2. Prepare AUR environment.

       sudo pacman -Syyu git base-devel --noconfirm

3. Clone Jellyfin AUR repository and install Jellyfin.

       mkdir git && cd git && git clone https://aur.archlinux.org/jellyfin.git && cd jellyfin && makepkg -sirc
       # or
       mkdir git && cd git && git clone https://aur.archlinux.org/jellyfin-bin.git && cd jellyfin-bin && makepkg -sirc

4. Enable and start Jellyfin.

       systemctl enable --now jellyfin && systemctl status jellyfin
