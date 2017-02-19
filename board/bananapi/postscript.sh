#!/bin/sh

UBOOT_HOST_DIR=$TARGET/../build/host-uboot-tools-*

cp $IMG_DIR/uImage $BOOT_DIR
cp $IMG_DIR/sun7i-a20-bananapi.dtb $BOOT_DIR

$UBOOT_HOST_DIR/tools/mkimage -C none -A arm -T script -d $BOARD_DIR/boot.cmd $BOOT_DIR/boot.scr

