# Custom linux
This repository contains a [build script](../main/distribution/install.sh) to create a custom linux rootfs for aarch64 systems.<br>
You can also get premade rootfs images from the [Actions tab](https://github.com/System64fumo/linux/actions) if you want.<br>

> [!IMPORTANT]
> This guide is very W.I.P and quite bad at the moment.

### Why does this exist?
To provide a testing ground for mainline linux and experimental software, And to show the potential of an optimized linux install.<br>

### What software is used in this?
Window manager: Labwc (Hyprland coming soon)<br>
Graphical shell/UI: Sysshell<br>
Web Browser: LibreWolf<br>
File Manager: Frog & Nemo (Frog is still in development so nemo is provided as a fallback)<br>
Terminal: Foot<br>
Init System: Busybox SysV Init<br>
Base Distribution: Artix Linux (ARMtix linux)<br>

### What platforms does this support?
Technically this supports most if not all aarch64 systems that run mainline linux.<br>
You *can* use downstream/vendor linux buuuut it might not work.<br>

# Installation
An easier to use GUI based setup is being worked, But for the time being manual labor is needed.<br>
The installation process here differs from what most are used to, Mostly due to me wanting to support as much devices as i can and because it just makes sense to do it this way.<br>
You're going to need boot files from either your board's OEM distribution or a community one.<br>

1. Wipe your desired storage medium (MicroSD/SSD/Etc..)<br>
2. Create a 128mb fat32 partition and fill the rest of the space with a filesystemless partition (Or use any other filesystem, You will replace later it anyway)<br>
3. Restore the rootfs.img file into the second partition (Using dd, gnome-disk-utility, etc..)<br>
4. Copy `/usr/lib/modules/*` from your OEM's distro to the new rootfs<br>
5. Copy `/usr/lib/firmware` from your OEM's distro to the new rootfs (Only if you need WiFi or Bluetooth)<br>
6. Copy the boot files from your OEM's distro into the new boot partition<br>
7. Change the cmdline so `root=/dev/blablabla` points to the correct root partition (eg. /dev/mmcblk0p2)<br>

Done!<br>

### For devices using UBoot it's recommended that you use extlinux<br>
`/boot/extlinux/extlinux.conf`
```
LABEL artix-linux
  Linux /Image
  FDT /rk3588-orangepi-5-plus.dtb
  APPEND console=tty1 loglevel=7 root=/dev/mmcblk1p2 rw rootwait
```
