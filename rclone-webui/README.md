# Rclone WebUI Arch Linux installation (run as root user inside the LXC)

### 1. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/rclone-webui/rclone-webui_installer.sh)
  ```
### 2. Configure a remote on a headless machine.

1. Login as root to the LXC running Rclone WebUI.
2. Run the command below to start the configuration of a new remote. For additional help please refer to the documentation of Rclone.
   ```
   runuser -u rclone-webui -- rclone config
   ```

<br />
<br />
<br />
<br />
<hr>

# Rclone WebUI Arch Linux update installation (run as root user inside the LXC)

### 1. Perform a full system maintenance and reboot the LXC.

  ```
  see main page
  ```
