# Arch Linux LXC: initial configuration (run as root user inside the LXC)

1. Extract compatibility trust certificate bundles inside of the Arch Linux LXC.

   ```
   trust extract-compat
   ```

2. Get the script URL with a valid token by visiting: https://github.com/TheHellSite/archlinux_lxc/raw/main/initial_config.sh

3. Run the script inside of the Arch Linux LXC.

   ```
   bash <(curl -s URL)
   ```



# Arch Linux LXC: add non-root user (run as root user inside the LXC)

1. Get the script URL with a valid token by visiting: https://github.com/TheHellSite/archlinux_lxc/raw/main/add_user.sh

2. Run the script inside of the Arch Linux LXC.

   ```
   bash <(curl -s URL)
   ```



# Jellyfin Arch Linux installation (run as non-root user inside the LXC)

1. Get the script URL with a valid token by visiting: https://github.com/TheHellSite/archlinux_lxc/raw/main/install_jellyfin.sh

2. Run the script inside of the Arch Linux LXC.

   ```
   bash <(curl -s URL)
   ```

3. (optional) Mount NAS media share as read-only and mount transcodes folder as read-write.

   ```
   sudo systemctl stop jellyfin && sudo pacman -Syyu cifs-utils --noconfirm && sudo mkdir /mnt/media /var/lib/jellyfin/transcodes && sudo chown jellyfin:jellyfin /mnt/media /var/lib/jellyfin/transcodes
   
   { echo '//NAS/nas/Media/ /mnt/media cifs _netdev,noatime,uid=jellyfin,gid=jellyfin,user=SMBUSER_R,pass=SMBPASSWORD_R 0 0' ; echo '//NAS/nas/Media/Transcodes /var/lib/jellyfin/transcodes cifs _netdev,noatime,uid=jellyfin,gid=jellyfin,user=SMBUSER_RW,pass=SMBUSER_RW 0 0' } | sudo tee -a /etc/fstab
   
   sudo mount -a && ls /mnt/media
   
   sudo systemctl start jellyfin && sudo systemctl status jellyfin
   ```



# Jellyfin LXC GPU passthrough (run as root user)

1. **PVE Host:** Get the render device ID.

   ```
   ls -l /dev/dri
   ```

   Example output:
   ```
   total 0
   drwxr-xr-x 2 root root         80 Oct  1 10:51 by-path
   crw-rw---- 1 root video  226,   0 Oct  1 10:51 card0
   crw-rw---- 1 root render 226, 128 Oct  1 10:51 renderD128
   
   --> In this case "226,128" is the render device ID.
   ```

2. **PVE Host:** Shutdown the LXC, change the LXC configuration and start the LXC.

       { echo 'lxc.cgroup2.devices.allow: c 226:128 rwm' ; echo 'lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file' ; echo 'lxc.autodev: 1' ; echo 'lxc.hook.autodev: sh -c "chown 0:989 /dev/dri/renderD128"' ; } >> /etc/pve/lxc/LXC_ID.conf

   <details>
   <summary><b>Command explanation</b></summary>
     
     1. Grant the LXC access to the render device of the PVE host.  
        ```lxc.cgroup2.devices.allow: c 226:128 rwm```
     2. Mount the render device in the LXC.  
        ```lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file```
     3. Enable "lxc.autodev" for the LXC, necessary in order to use "lxc.hook.autodev".  
        ```lxc.autodev: 1```
     4. Change UID and GID of the render device to root:render in the LXC during every start of it.  
        ```lxc.hook.autodev: sh -c "chown 0:989 /dev/dri/renderD128"```
   </details>

   **!!! Adjust "LXC_ID" at the end of the command !!! (necessary)**\
   !!! Adjust the render device ID !!! *(if necessary)*\
   !!! Adjust the GID in the "chown" command to match the GID of group "render" in your LXC !!! *(if necessary)*



3. **LXC Guest:** Start the LXC, add user "jellyfin" to group "render", install the latest Mesa drivers and reboot the LXC.

   ```
   usermod -aG render jellyfin && pacman -Syyu --noconfirm mesa libva-mesa-driver && reboot
   ```

4. **Jellyfin:** Enable VAAPI.

   Go to: Admin --> Server --> Dashboard --> Playback
   ```
   Hardware acceleration: VAAPI
   VA API Device: /dev/dri/renderD128
   Enable hardware decoding for: Check all codecs supported by your GPU.
   ```

5. **(optional) LXC Guest:** Check if transcoding is working, f.e. by playing and downscaling a video.

   **Method 1:** Install ```radeontop``` in the LXC. You should see activity, f.e. at the "Graphics pipe".
   ```
   pacman -S radeontop --noconfirm && radeontop
   ```

   **Method 2:** Watch the transcodes folder. Jellyfin should constantly create new files during playback and delete them afterwards.



# Vaultwarden installation (run as root user inside the LXC)

1. Get the script URL with a valid token by visiting: https://github.com/TheHellSite/archlinux_lxc/raw/main/install_vaultwarden.sh

2. Run the script inside of the Arch Linux LXC.

   ```
   bash <(curl -s URL)
   ```
