# Jellyfin Arch Linux installation (run as root user inside the LXC)

### 1. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/jellyfin/jellyfin_installer.sh)
  ```

<br />
<br />
<br />
<br />
<hr>

# Jellyfin Arch Linux update installation (run as root user inside the LXC)

### 1. Perform a full system maintenance and reboot the LXC.

  ```
  pacman -Sy --noconfirm archlinux-keyring && pacman -Su --noconfirm && if pacman -Qtdq >/dev/null; then pacman -Rns --noconfirm $(pacman -Qtdq); fi && yes | pacman -Scc && reboot
  ```

<br />
<br />
<br />
<br />
<hr>

# Jellyfin VA-API hardware accelerated video transcoding (run as root user)

The guide below should work for all GPUs listed here: https://docs.mesa3d.org/systems.html  
Please note that `pacman` is the package manager in Arch Linux, if you are using another distro as your LXC base system, f.e. Debian, you will have to use the respective package manager to install the below dependencies.

### 1. PVE Host: Passthrough the render device to the LXC and assign it to group render (GID=989).

  > [!IMPORTANT]
  > The tone mapping device `/dev/kfd` is specific to AMD (i)GPUs and therefore not available on other (i)GPUs.

  ```
  cat <<EOF >> /etc/pve/lxc/LXC_ID.conf
  dev0: /dev/dri/renderD128,gid=989
  dev1: /dev/kfd,gid=989
  EOF
  ```

### 2. LXC Guest: Add the service user "jellyfin" to group "render".

  ```
  gpasswd -a jellyfin render
  ```

### 3. LXC Guest: Install the Mesa driver.

  ```
  pacman -Syu --needed --noconfirm mesa
  ```

### 4. LXC Guest: Install dependencies for FFmpeg for Jellyfin.

**AMD specific dependencies**  
`libva-mesa-driver`: AMD VA-API support  
`vulkan-radeon`: AMD RADV support  
`opencl-amd`: AMD OpenCL runtime based Tonemapping *(only for Jellyfin v10.8.x and older)*  

  ```
  pacman -Syu --needed --noconfirm libva-mesa-driver vulkan-radeon
  ```

**Intel specific dependencies**  
`intel-media-driver`: Intel VAAPI support (Broadwell and newer)  
`libva-intel-driver`: Intel legacy VAAPI support (10th Gen and older)  
`intel-media-sdk`: Intel Quick Sync Video  
`onevpl-intel-gpu`: Intel Quick Sync Video (12th Gen and newer)  
`intel-compute-runtime`: Intel OpenCL runtime based Tonemapping  
`nvidia-utils`: Nvidia NVDEC/NVENC support  
`vulkan-intel`: Intel ANV Vulkan support  

  ```
  Please select the relevant packages on your own. I don't have any Intel (i)GPUs and therefore can't validate the needed ones.
  ```

### 5. Jellyfin: Enable VA-API.

  Go to: Admin --> Server --> Dashboard --> Playback
  ```
  Hardware acceleration: VAAPI
  VA-API-Device: /dev/dri/renderD128
  Enable hardware decoding for: Check all codecs supported by your GPU.
  ```

### 6. (optional) LXC Guest: Check if transcoding is working, f.e. by playing and downscaling a video.

  **Method 1:** Watch the transcodes folder. Jellyfin should constantly create new files during playback and delete them afterwards.

  **Method 2:** Install ```vainfo``` in the LXC and check for the line `libva info: va_openDriver() returns 0`.
  ```
  pacman -Syu --needed --noconfirm libva-utils && vainfo
  ```
