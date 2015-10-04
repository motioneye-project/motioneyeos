#!/bin/sh

# copy System.map
cp $TARGET/../build/linux-*/System.map $TARGET/System.map

# boot directory
mkdir -p $BOOT_DIR

cp $IMG_DIR/uImage $BOOT_DIR
cp $IMG_DIR/meson8b_odroidc.dtb $BOOT_DIR
cp $BOARD_DIR/bl1.bin.hardkernel $IMG_DIR
cp $BOARD_DIR/u-boot.bin $IMG_DIR
cp $BOARD_DIR/boot.ini $BOOT_DIR

# disable software updating
sed -i 's/enable_update true/enable_update false/' $TARGET/etc/motioneye.conf
