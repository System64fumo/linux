#!/bin/sh

ROOTFSURL=""
ROOTFSFILE=./rootfs.img
MOUNTPATH=./mount

# Request root access
if [[ "$(whoami)" != "root" ]]; then
	echo "This script needs to run as root."
	exit
fi

# Get rootfs
REMOTE_FILE=$(curl -s https://armtixlinux.org/images/sha256sums | grep armtix-dinit | cut -d ' ' -f 3)
ROOTFSURL="https://armtixlinux.org/images/$REMOTE_FILE"

mkdir $MOUNTPATH

# Create rootfs if missing
[ -f "$ROOTFSFILE" ] || (truncate -s 4G "$ROOTFSFILE"; mkfs.btrfs "$ROOTFSFILE" -qL rootfs)

mount "$ROOTFSFILE" "$MOUNTPATH" -o rw,noatime,compress=zstd

echo "Downloading rootfs file..."
curl -#L "$ROOTFSURL" --keepalive-time 120 | tar -xpJC $MOUNTPATH/

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

echo "Done!"
