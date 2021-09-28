# Arch Linux LXC initial config (run as root user inside the LXC)

1. Extract compatibility trust certificate bundles inside of the Arch Linux LXC.

       trust extract-compat

2. Get the script URL with a valid token by visiting: https://github.com/TheHellSite/archlinux_lxc/raw/main/initial_config.sh

3. Run the script inside of the Arch Linux LXC.

       bash <(curl -s URL)



# Arch Linux LXC add non-root user (run as root user inside the LXC)

1. Get the script URL with a valid token by visiting: https://github.com/TheHellSite/archlinux_lxc/raw/main/add_user.sh

2. Run the script inside of the Arch Linux LXC.

       bash <(curl -s URL)



# Jellyfin Arch Linux installation (run as non-root user inside the LXC)

1. Prepare AUR environment.

       sudo pacman -Syyu git base-devel --noconfirm

2. Clone Jellyfin AUR repository and install Jellyfin.

       # https://aur.archlinux.org/packages/jellyfin-bin/ (usually more up-to-date)
       mkdir git && cd git && git clone https://aur.archlinux.org/jellyfin-bin.git && cd jellyfin-bin && makepkg -sirc
       
       # or
       
       # https://aur.archlinux.org/packages/jellyfin/ (sometimes a bit out-of-date)
       mkdir git && cd git && git clone https://aur.archlinux.org/jellyfin.git && cd jellyfin && makepkg -sirc

3. Mount NAS share. (optional)

       sudo pacman -Syyu cifs-utils --noconfirm
       sudo mkdir /mnt/media /var/lib/jellyfin/transcodes && sudo chown jellyfin:jellyfin /mnt/media /var/lib/jellyfin/transcodes
       echo '//NAS/nas/Media/ /mnt/media cifs _netdev,noatime,uid=jellyfin,gid=jellyfin,user=SMBUSER_R,pass=SMBPASSWORD_R 0 0' | sudo tee -a /etc/fstab
       echo '//NAS/nas/Media/Transcodes /var/lib/jellyfin/transcodes cifs _netdev,noatime,uid=jellyfin,gid=jellyfin,user=SMBUSER_RW,pass=SMBUSER_RW 0 0' | sudo tee -a /etc/fstab
       sudo mount -a && ls /mnt/media

4. Enable and start Jellyfin.

       sudo systemctl enable --now jellyfin && sudo systemctl status jellyfin



# Jellyfin LXC GPU passthrough (run as root user)

1. **Proxmox Host:** Find the GPU device number.

       ls -l /dev/dri

2. **Proxmox Host:** Add it to the LXC configuration file.

       nano /etc/pve/lxc/LXC_ID.conf
       
       lxc.cgroup2.devices.allow: c 226:128 rwm
       lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file

3. **LXC Guest:** Start the LXC, assign render device to group render, install the latest Mesa drivers and reboot the LXC.

       chown root:render /dev/dri/renderD128
       usermod -aG render jellyfin
       pacman -Syyu mesa libva-mesa-driver --noconfirm && reboot       

4. **Jellyfin:** Enable VAAPI.

       Go to: Admin --> Server --> Dashboard --> Playback
       Hardware acceleration: VAAPI
       VA API Device: /dev/dri/renderD128

5. **LXC Guest:** Check if transcoding is working, f.e. by playing and downscaling a video. (optional)

       pacman -S radeontop --noconfirm && radeontop
       --> You should see activity, f.e. at the "Graphics pipe".



# Vaultwarden installation (run as root user inside the LXC)

1. Get the script URL with a valid token by visiting: https://github.com/TheHellSite/archlinux_lxc/raw/main/install_vaultwarden.sh

2. Run the script inside of the Arch Linux LXC.

       bash <(curl -s URL)
