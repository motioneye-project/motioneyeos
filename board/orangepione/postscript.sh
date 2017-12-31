#!/bin/sh

cp $IMG_DIR/zImage $BOOT_DIR
cp $IMG_DIR/sun8i-h3-orangepi-one.dtb $BOOT_DIR
cp $BOARD_DIR/boot.scr $BOOT_DIR
cp $BOARD_DIR/boot-fwupdater.scr $BOOT_DIR

