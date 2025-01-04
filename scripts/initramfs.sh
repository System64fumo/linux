#!/bin/sh

find ./initramfs -print0 |\
cpio --null --create --format=newc |\
zstd -1 > ./initramfs.zst
