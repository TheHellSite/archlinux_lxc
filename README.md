# About this repository

Each subfolder contains an indiviual README.md file explaining how to install and configure certain services.\
Beware that the scripts are only tested to be working on a freshly made Arch Linux LXC running on Proxmox.

<br />
NOTE: pyload-ng is still having issues with https, so you will need to disable ssl after installing it using my script.

<br />
<hr>

# Things to know about Arch Linux LXCs on Proxmox

1. Arch Linux LXCs need to have "nesting=enabled" in order for networking to function properly.
