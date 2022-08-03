# Jellyfin Arch Linux installation (run as non-root user inside the LXC)

### 1. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/jellyfin/jellyfin_installer.sh)
  ```

<br />
<br />
<br />
<br />
<hr>

# Jellyfin Arch Linux update installation (run as non-root user inside the LXC)

### 1. Perform a full system upgrade and reboot the LXC.

  ```
  sudo pacman -Syy archlinux-keyring -noconfirm && sudo pacman -Syyu && sudo reboot
  ```

### 2. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/jellyfin/jellyfin_updater.sh)
  ```

<br />
<br />
<br />
<br />
<hr>

# Jellyfin LXC GPU passthrough (run as root user)

The GPU passthrough guide below should work for all GPUs listed here: https://docs.mesa3d.org/systems.html

### 1. PVE Host: Get the render device ID.

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

### 2. PVE Host: Shutdown the LXC, run one of the commands below and start the LXC.

  **!!! Adjust "LXC_ID" at the end of the command !!! (necessary)**\
  !!! Adjust the render device ID !!! *(if necessary)*\
  !!! Adjust the GID=989 in the "chown" command to match the GID of group "render" in your LXC !!! *(if necessary)*

  ```
  # use the command below if your LXC is unprivileged
  { echo 'lxc.cgroup2.devices.allow: c 226:128 rwm' ; echo 'lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file' ; echo 'lxc.hook.pre-start: sh -c "chown 0:100989 /dev/dri/renderD128"' ; } | tee -a /etc/pve/lxc/LXC_ID.conf
  
  # use the command below if your LXC is privileged
  { echo 'lxc.cgroup2.devices.allow: c 226:128 rwm' ; echo 'lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file' ; echo 'lxc.hook.pre-start: sh -c "chown 0:989 /dev/dri/renderD128"' ; } | tee -a /etc/pve/lxc/LXC_ID.conf
  ```

  <details>
  <summary><b>Command explanation</b></summary>
    
    1. Grant the LXC access to the render device of the PVE host.  
           lxc.cgroup2.devices.allow: c 226:128 rwm
    2. Mount the render device in the LXC.  
           lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file
    3. Change UID and GID of the render device to root:render on the PVE host during each start of the LXC.  
           lxc.hook.pre-start: sh -c "chown 0:100989 /dev/dri/renderD128"
  </details>

### 3. LXC Guest: Start the LXC, add user "jellyfin" to group "render", install the latest Mesa drivers and reboot the LXC.

  ```
  usermod -aG render jellyfin && pacman -Syyu --needed --noconfirm mesa libva-mesa-driver && reboot
  ```

### 4. Jellyfin: Enable VAAPI.

  Go to: Admin --> Server --> Dashboard --> Playback
  ```
  Hardware acceleration: VAAPI
  VA API Device: /dev/dri/renderD128
  Enable hardware decoding for: Check all codecs supported by your GPU.
  ```

### 5. (optional) LXC Guest: Check if transcoding is working, f.e. by playing and downscaling a video.

  **Method 1:** Install ```radeontop``` in the LXC. You should see activity, f.e. at the "Graphics pipe".
  ```
  pacman -Syyu --needed --noconfirm radeontop && radeontop
  ```

  **Method 2:** Watch the transcodes folder. Jellyfin should constantly create new files during playback and delete them afterwards.
