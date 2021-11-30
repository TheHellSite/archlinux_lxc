# Disclaimer

**!!! Make a backup of your LXC before running any of my scripts or commands in it. !!!**

Even though I tested these scripts to be working well on my system they can still misbehave on your system.\
I take no responsibility at all for anything that happens to your system or your data.

<br />
<br />
<hr>

# About this repository

1. These scripts are only tested to be working on a freshly made Arch Linux LXC running on Proxmox.

2. Each subfolder contains an indiviual README.md file explaining how to install and configure certain services.

3. **Watch out for scripts and commands that need to be run as non-root user! (i.e. Jellyfin, Plex Media Server, ...)**

<br />
<br />
<hr>

# Things to know about Arch Linux LXCs on Proxmox

1. Arch Linux LXCs need to have "nesting=enabled" in order for networking to function properly.

2. Partial system / package updates are not supported (not advisable) on Arch Linux.\
   Because of that my scripts always perform a full LXC system upgrade while installing new packages.\
   https://wiki.archlinux.org/title/System_maintenance#Partial_upgrades_are_unsupported
