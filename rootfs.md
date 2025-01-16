# RootFS
The following guide will help you create a linux root filesystem image that can be flashed to a storage medium of your choosing.<br>

> [!NOTE]
> The rootfs creation process is generic and should work for any of the distros listed [here](misc.md#distros) but this guide will use ARMtix as an example.<br>
> This guide only creates a generic rootfs, You will still need a bootfs, bootloader, kernel, modules, firmware, etc...<br>
> A script to automate all of this is planned but for now you'll have to do this manually<br>

## Requirements
1. An machine running linux with the same architecture of the desired rootfs (Or set up binfmt)
2. Your desired distro's rootfs
3. 4GB or more of storage

## Initial setup
1. Create root.img<br>
`truncate -s 4G rootfs.img`<br>

2. Format it with btrfs<br>
`mkfs.btrfs rootfs.img -qL rootfs`<br>

3. Create a mount dir<br>
`mkdir /tmp/mount`<br>
3.1. Mount the root<br>
`mount rootfs.img /tmp/mount -o rw,noatime,compress=zstd`<br>

4. Start downloading your rootfs to the mount<br>
`curl -#L "https://armtixlinux.org/images/armtix-dinit-20241207.tar.xz" --keepalive-time 120 | bsdtar -xpC /tmp/mount/`<br>

5. (Optional) Chroot into the rootfs<br>
`mount -t proc /proc /tmp/mount/proc/`<br>
`mount -t sysfs /sys /tmp/mount/sys/`<br>
`mount --rbind /dev /tmp/mount/dev/`<br>
`chroot /tmp/mount`<br>

6. Cleanup<br>
`umount -fR /tmp/mount/{proc,sys,dev}`<br>
`umount -fR /tmp/mount`<br>
`sync`<br>

And that's it!
You can now flash your rootfs to your target device.<br>
