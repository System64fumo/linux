#!/bin/sh

KERNEL=/path/to/Image.gz
DTB=/path/to/device-tree.dtb
RAMDISK=/path/to/initramfs.zst
CMDLINE="earlycon loglevel=7 console=tty1"

echo "Appending device tree to the kernel.."
cat $KERNEL $DTB > /tmp/vmlinuz-dtb

echo "Creating boot.img."
echo "Kernel: $KERNEL"
echo "Initramfs: $RAMDISK"
echo "DTB: $DTB"
echo "Cmdline: $CMDLINE"
mkbootimg \
--kernel /tmp/vmlinuz-dtb \
--cmdline "$CMDLINE" \
--base 0x80000000 \
--second_offset 0x00f00000 \
--kernel_offset 0x00080000 \
--tags_offset 0x00000100 \
--ramdisk "$RAMDISK" \
--ramdisk_offset 0x02000000 \
--pagesize 4096 \
-o boot.img
