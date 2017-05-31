#!/bin/sh

# boot directory
mkdir -p $BOOT_DIR/pine64

cp $IMG_DIR/Image $BOOT_DIR/pine64
cp $IMG_DIR/pine64.dtb $BOOT_DIR
cp $IMG_DIR/pine64plus.dtb $BOOT_DIR
cp $BOARD_DIR/boot0.bin $IMG_DIR
cp $BOARD_DIR/u-boot.bin $IMG_DIR
cp $BOARD_DIR/boot.ini $BOOT_DIR
#cp $BOARD_DIR/uInitrd $BOOT_DIR

