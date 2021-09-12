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
