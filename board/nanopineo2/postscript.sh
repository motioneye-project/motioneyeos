#!/bin/sh

cp $IMG_DIR/Image $BOOT_DIR
cp $BOARD_DIR/boot.scr $BOOT_DIR
cp $BOARD_DIR/boot-fwupdater.scr $BOOT_DIR
cp $BOARD_DIR/sun50i-h5-nanopi-neo2.dtb $BOOT_DIR
cp $BOARD_DIR/rootfs.cpio.uboot $BOOT_DIR

