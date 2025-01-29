#!/bin/sh

ROOTSOURCE="./root.tar.xz"
ROOTOUTPUT=./rootfs.img
MOUNTPATH=./mount

# Request root access
if [[ "$(whoami)" != "root" ]]; then
	echo "This script needs to run as root."
	exit
fi

mkdir $MOUNTPATH

# Create rootfs if missing
[ -f "$ROOTOUTPUT" ] || (truncate -s 4G "$ROOTOUTPUT"; mkfs.btrfs "$ROOTOUTPUT" -qL rootfs)

mount "$ROOTOUTPUT" "$MOUNTPATH" -o rw,noatime,compress=zstd

if [ ! -f "$ROOTSOURCE" ]; then
	echo "Downloading rootfs file..."
	REMOTE_FILE=$(curl -s https://armtixlinux.org/images/sha256sums | grep armtix-dinit | cut -d ' ' -f 3)
	ROOTFSURL="https://armtixlinux.org/images/$REMOTE_FILE"
	curl -#L "$ROOTFSURL" --keepalive-time 120 -o "$ROOTSOURCE"
fi

echo "Writing rootfs..."
cat "$ROOTSOURCE" | tar -xpJC $MOUNTPATH/

echo "Copying files..."
chmod +x ./files/chroot-install.sh
cp -r ./files $MOUNTPATH/opt/setup

echo "Chrooting..."
mount -t proc /proc $MOUNTPATH/proc/
mount -t sysfs /sys $MOUNTPATH/sys/
mount --rbind /dev $MOUNTPATH/dev/

chroot $MOUNTPATH /opt/setup/chroot-install.sh

# Unmount
umount -fR $MOUNTPATH
sync
rmdir $MOUNTPATH

echo "Done!"
