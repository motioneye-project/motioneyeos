#!/bin/sh

set -e

# boot directory
mkdir -p $BOOT_DIR

cp $IMG_DIR/Image $BOOT_DIR
cp $IMG_DIR/meson64_odroidc2.dtb $BOOT_DIR
cp $BOARD_DIR/bl1.bin.hardkernel $IMG_DIR
cp $BOARD_DIR/u-boot.bin $IMG_DIR
cp $BOARD_DIR/boot.ini $BOOT_DIR
cp $BOARD_DIR/uInitrd $BOOT_DIR

