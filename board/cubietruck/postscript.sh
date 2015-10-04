#!/bin/sh

UBOOT_HOST_DIR=$TARGET/../build/host-uboot-tools-*

# copy System.map
cp $TARGET/../build/linux-*/System.map $TARGET/System.map

cp $IMG_DIR/uImage $BOOT_DIR
cp $IMG_DIR/sun7i-a20-cubietruck.dtb $BOOT_DIR

$UBOOT_HOST_DIR/tools/mkimage -C none -A arm -T script -d $BOARD_DIR/boot.cmd $BOOT_DIR/boot.scr

# disable software updating
sed -i 's/enable_update true/enable_update false/' $TARGET/etc/motioneye.conf
