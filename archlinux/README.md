# Arch Linux LXC: initial configuration (run as root user inside the LXC)

### 1. Extract compatibility trust certificate bundles.

  ```
  trust extract-compat
  ```

### 2. Run the script inside of the Arch Linux LXC.

  ```
  bash <(curl -s https://raw.githubusercontent.com/TheHellSite/archlinux_lxc/main/archlinux/archlinux_initial_config.sh)
  ```
