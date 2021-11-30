# About this repository

1. These scripts are only tested to be working on a freshly made Arch Linux LXC running on Proxmox.

2. Each subfolder contains an indiviual README.md file explaining how to install and configure certain services.

3. **Watch out for scripts and commands that need to be run as non-root user! (i.e. Jellyfin, Plex Media Server, ...)**

<br />
<br />
<hr>

# Things to know about Arch Linux LXCs on Proxmox

1. Arch Linux LXCs need to have "nesting=enabled" in order for networking to function properly.
