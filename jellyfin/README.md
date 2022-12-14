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

# Jellyfin VA-API hardware accelerated video transcoding (run as root user)

The guide below should work for all GPUs listed here: https://docs.mesa3d.org/systems.html

### 1. Follow this tutorial to passthrough the render device to the LXC.
https://github.com/TheHellSite/proxmox_tutorials/tree/main/lxc_gpu_passthrough

### 2. Install the Mesa driver.

  ```
  pacman -Syyu --needed --noconfirm mesa
  ```

### 3. LXC Guest: Install dependencies for FFmpeg5 for Jellyfin dependencies.

**AMD specific dependencies**  
`libva-mesa-driver`: AMD VAAPI support  
`vulkan-radeon`: AMD RADV Vulkan support  
`opencl-amd`: AMD OpenCL runtime based Tonemapping *(only for Jellyfin v10.8.x and older)*  

  ```
  pacman -Syyu --needed --noconfirm libva-mesa-driver opencl-mesa vulkan-radeon
  ```

**Intel specific extras**  
`intel-media-driver`: Intel VAAPI support (Broadwell and newer)  
`intel-media-sdk`: Intel Quick Sync Video  
`onevpl-intel-gpu`: Intel Quick Sync Video (12th Gen and newer)  
`intel-compute-runtime`: Intel OpenCL runtime based Tonemapping  
`libva-intel-driver`: Intel legacy VAAPI support (10th Gen and older)  
`nvidia-utils`: Nvidia NVDEC/NVENC support  
`vulkan-intel`: Intel ANV Vulkan support  

  ```
  Please select the relevant packages on your own. I don't have any Intel (i)GPUs and therefore can't validate the needed ones.
  ```

### 4. Jellyfin: Enable VA-API.

  Go to: Admin --> Server --> Dashboard --> Playback
  ```
  Hardware acceleration: VAAPI
  VA API Device: /dev/dri/renderD128
  Enable hardware decoding for: Check all codecs supported by your GPU.
  ```

### 3. (optional) LXC Guest: Check if transcoding is working, f.e. by playing and downscaling a video.

  **Method 1:** Watch the transcodes folder. Jellyfin should constantly create new files during playback and delete them afterwards.

  **Method 2:** Install ```radeontop``` in the LXC. You should see activity, f.e. at the "Graphics pipe".
  ```
  pacman -Syyu --needed --noconfirm radeontop && radeontop
  ```
