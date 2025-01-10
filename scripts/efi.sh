#!/bin/sh

BOOTDISK="/dev/nvme0n1"
BOOTPART="1"
ROOTUUID="26ed43d0-22cb-432c-9638-646292333042"
LABEL="Linux"
KERNEL="/vmlinuz"
INITRAMFS="/initramfs-linux.img"
PARAMATERS='rw loglevel=7 console=tty1'

echo "Deleting previous entry..."
efibootmgr -BL "$LABEL" &> /dev/null
sleep 0.5

echo "Generating new entry..."
efibootmgr \
--create \
--disk $BOOTDISK \
--part $BOOTPART \
--label $LABEL \
--loader $KERNEL \
--unicode "initrd=$INITRAMFS root=PARTUUID=$ROOTUUID $PARAMATERS" &> /dev/null

efibootmgr
echo "Done."
