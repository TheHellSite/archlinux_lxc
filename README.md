# Arch Linux LXC initial config script (run commands as root user)

1. Extract compatibility trust certificate bundles inside of the Arch Linux LXC.

       trust extract-compat

2. Get the script URL with a valid token by visiting: https://github.com/TheHellSite/archlinux_lxc/raw/main/initial_config.sh

3. Run the script inside of the Arch Linux LXC.

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

2. **Proxmox Host:** Add them to the LXC configuration file.

       nano /etc/pve/lxc/LXC_ID.conf
       add the lines below...
       
       lxc.cgroup2.devices.allow: c 226:0 rwm
       lxc.cgroup2.devices.allow: c 226:128 rwm
       lxc.autodev: 1
       lxc.hook.autodev:/var/lib/lxc/LXC_ID/mount_hook.sh

3. **Proxmox Host:** Create the shell script that mounts the GPU when the LXC starts.

       nano /var/lib/lxc/LXC_ID/mount_hook.sh
       add the lines below...
       
       #!/bin/bash
       mkdir -p ${LXC_ROOTFS_MOUNT}/dev/dri
       mknod -m 666 ${LXC_ROOTFS_MOUNT}/dev/dri/card0 c 226 0
       mknod -m 666 ${LXC_ROOTFS_MOUNT}/dev/dri/renderD128 c 226 128
       # only necessary for Intel iGPU
       # mknod -m 666 ${LXC_ROOTFS_MOUNT}/dev/fb0 c 29 0

4. **Proxmox Host:** Make the script executable.

       chmod 0755 /var/lib/lxc/LXC_ID/mount_hook.sh

5. **LXC Guest:** Start the LXC, install the latest Mesa drivers and reboot the LXC.

       pacman -Syyu mesa --noconfirm && reboot

6. **Jellyfin:** Enable VAAPI.

       Go to: Admin --> Server --> Dashboard --> Playback
       Hardware acceleration: VAAPI
       VA API Device: /dev/dri/renderD128
