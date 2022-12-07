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
  sudo pacman -Syy --noconfirm archlinux-keyring && sudo pacman -Su && sudo reboot
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

### 1. Follow this tutorial.
https://github.com/TheHellSite/proxmox_tutorials/tree/main/lxc_gpu_passthrough

### 2. Jellyfin: Enable VAAPI.

  Go to: Admin --> Server --> Dashboard --> Playback
  ```
  Hardware acceleration: VAAPI
  VA API Device: /dev/dri/renderD128
  Enable hardware decoding for: Check all codecs supported by your GPU.
  ```

### 3. (optional) LXC Guest: Check if transcoding is working, f.e. by playing and downscaling a video.

  **Method 1:** Install ```radeontop``` in the LXC. You should see activity, f.e. at the "Graphics pipe".
  ```
  pacman -Syyu --needed --noconfirm radeontop && radeontop
  ```

  **Method 2:** Watch the transcodes folder. Jellyfin should constantly create new files during playback and delete them afterwards.
