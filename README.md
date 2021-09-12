# Arch Linux LXC initial config script (run as root user)

1. Extract compatibility trust certificate bundles inside of the Arch Linux LXC.

       trust extract-compat

2. Get the script URL with a valid token by visiting: https://github.com/TheHellSite/archlinux_lxc/raw/main/initial_config.sh

3. Run the script inside of the Arch Linux LXC.

       bash <(curl -s URL)


# Jellyfin installation (run as non-root user)

1. Prepare AUR environment.

       sudo pacman -Syyu git base-devel --noconfirm

2. Clone Jellyfin AUR repository and install Jellyfin.

       mkdir git && cd git && git clone https://aur.archlinux.org/jellyfin.git && cd jellyfin && makepkg -sirc
       or
       mkdir git && cd git && git clone https://aur.archlinux.org/jellyfin-bin.git && cd jellyfin-bin && makepkg -sirc

3. Enable and start Jellyfin.

       systemctl enable jellyfin

4. Mount NAS share.

       pacman -Syyu cifs-utils
       sudo mkdir /mnt/nas
       sudo mount -t cifs -o user=USER,pass=PASSWORD //10.13.54.251/nas /mnt/nas
       /mnt/nas cifs user=USER,pass=PASSWORD,vers=3.11,uid=vod,_netdev 0 0
