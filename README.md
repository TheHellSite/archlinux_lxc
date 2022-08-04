# About this repository

1. The "archlinux" subfolder contains the `archlinux_initial_config.sh` that will get your new Arch Linux LXC ready to be used for whatever purpose you like.\
   You should run this script everytime you created a new Arch Linux LXC.

2. Each subfolder contains an indiviual README.md file explaining how to install and configure certain services.

3. **Watch out for scripts and commands that need to be run as non-root user! (i.e. Jellyfin, Plex Media Server, ...)**

<br />
<br />
<hr>

# Troubleshooting

1. If you haven't updated your Arch Linux (LXC) in a while you will likely get some of the errors below when using any of my scripts.
   - invalid or corrupted package
   - Signature from "User <email@example.org>" is unknown trust
   
   To fix them you will have to do this: https://wiki.archlinux.org/title/Pacman/Package_signing#Upgrade_system_regularly
   
   ```
   pacman -Syy archlinux-keyring && pacman -Su && reboot
   ```

<br />
<br />
<hr>

# Things to know about Arch Linux LXCs on Proxmox

1. Arch Linux LXCs need to have `nesting=enabled` in order for networking to function properly.

2. Partial system / package updates are not supported (not advisable) on Arch Linux.\
   Because of that my scripts always perform a full LXC system upgrade while installing new packages.\
   https://wiki.archlinux.org/title/System_maintenance#Partial_upgrades_are_unsupported

<br />
<br />
<hr>

# Disclaimer

**!!! Make a backup of your LXC before running any of my scripts or commands in it. !!!**

These scripts are only tested to be working on a freshly made Arch Linux LXC running on Proxmox.\
Even though I tested these scripts to be working well on my system they can still misbehave on your system.\
I take no responsibility at all for anything that happens to your system or your data.
