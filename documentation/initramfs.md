# Initramfs
Initramfs is a filesystem that gets loaded early in the boot process.<br>
It's purpose is to load important modules for storage devices, filesystems, graphics, etc..<br>
However it can also be used for other things such as recovery, graphical splash screens, disk decryption, etc..<br>

Traditionally initramfs is a cruical part of the linux boot process for most systems.<br>
But some systems (eg. embedded) tend to skip that part altogether!<br>

### How?
You can typically bake in important modules directly into your kernel.<br>
In most cases this would be storage and filesystem ones as seen on a Raspberry Pi for instance.<br>

### Why?
In the case of embedded systems it's to reduce dependencies and resource usage.<br>
In other cases it would be to simply skip it if you don't need any fancy bells and whisles.<br>


# Creating an initramfs
To create a very basic initramfs you would have to do the following:
1. `mkdir -p initramfs/{dev,proc,sys,tmp,root,usr/bin,usr/sbin}`
2. `cd initramfs; ln -sr ./usr/bin ./bin; ln -sr ./usr/sbin ./sbin`
2. Download [busybox](https://www.busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/) into ./usr/bin/busybox
3. `sudo chmod +x ./usr/bin/busybox`
4. `sudo chroot . /usr/bin/busybox --install`
5. `rm ./linuxrc` (if it exists)
6. Create a new file called `init` and paste the following in it:
```sh
#!/bin/sh

# Mount psuedo filesystems.
mount -t devtmpfs none /dev
mount -t sysfs none /sys
mount -t proc none /proc

# Mount the root filesystem.
mount -o rw /dev/mmcblk0p1 /root

# Clean up.
umount /dev
umount /sys
umount /proc

# Boot the real thing.
exec switch_root /root /sbin/init
```
7. Be sure to `chmod +x ./init` otherwise it won't work
8. `cd ..` Then use the [provided script](scripts/initramfs.sh) to create and compress the initramfs.

And you're done!<br>
This file can be now used to initialize linux.
