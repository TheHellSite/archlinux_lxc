# Arch Linux LXC initial config script (run commands as root user)

1. Extract compatibility trust certificate bundles inside of the Arch Linux LXC.

       trust extract-compat

2. Get the script URL with a valid token by visiting: https://github.com/TheHellSite/archlinux_lxc/raw/main/initial_config.sh

3. Run the script inside of the Arch Linux LXC.

       bash <(curl -s URL)



# Arch Linux LXC add user (run commands as root user)

1. Get the script URL with a valid token by visiting: https://github.com/TheHellSite/archlinux_lxc/raw/main/add_user.sh

2. Run the script inside of the Arch Linux LXC.

       bash <(curl -s URL)



# Jellyfin installation (run commands as non-root user)

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

       sudo systemctl enable --now jellyfin && sudo systemctl status jellyfin



# Jellyfin LXC GPU passthrough

1. **Proxmox Host:** Find the GPU device number.

       ls -l /dev/dri

2. **Proxmox Host:** Add it to the LXC configuration file.

       nano /etc/pve/lxc/LXC_ID.conf
       add the lines below...
       
       lxc.cgroup2.devices.allow: c 226:0 rwm
       lxc.cgroup2.devices.allow: c 226:128 rwm
       lxc.mount.entry: /dev/dri/card0 dev/dri/card0 none bind,optional,create=file
       lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file

3. **LXC Guest:** Start the LXC, change group of render device, install the latest Mesa drivers and reboot the LXC.

       chgrp render /dev/dri/*
       usermod -aG render jellyfin
       pacman -Syyu mesa --noconfirm && reboot
       

4. **Jellyfin:** Enable VAAPI.

       Go to: Admin --> Server --> Dashboard --> Playback
       Hardware acceleration: VAAPI
       VA API Device: /dev/dri/renderD128



# Vaultwarden installation (run commands as root user)

1. Get the script URL with a valid token by visiting: https://github.com/TheHellSite/archlinux_lxc/raw/main/install_vaultwarden.sh

2. Run the script inside of the Arch Linux LXC.

       bash <(curl -s URL)
