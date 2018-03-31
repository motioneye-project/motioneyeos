#!/bin/sh

set -e

$HOST_DIR/bin/mkimage -C none -A arm -T script -d $BOARD_DIR/boot.cmd $BOOT_DIR/boot.scr
$HOST_DIR/bin/mkimage -C none -A arm -T script -d $BOARD_DIR/boot-fwupdater.cmd $BOOT_DIR/boot-fwupdater.scr

cp $IMG_DIR/zImage $BOOT_DIR
cp $IMG_DIR/sun8i-h3-orangepi-one.dtb $BOOT_DIR
cp $BOARD_DIR/rootfs.cpio.uboot $BOOT_DIR
