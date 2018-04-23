#!/bin/sh

set -e

# boot directory
mkdir -p $BOOT_DIR

cp $IMG_DIR/uImage $BOOT_DIR
cp $IMG_DIR/meson8b_odroidc.dtb $BOOT_DIR
cp $BOARD_DIR/bl1.bin.hardkernel $IMG_DIR
cp $BOARD_DIR/u-boot.bin $IMG_DIR
cp $BOARD_DIR/boot.ini $BOOT_DIR
cp $BOARD_DIR/uInitrd $BOOT_DIR

# fix some lib dirs
if ! [ -L $TARGET/lib/arm-linux-gnueabihf ]; then
    mv $TARGET/lib/arm-linux-gnueabihf/* $TARGET/lib
    rmdir $TARGET/lib/arm-linux-gnueabihf
    ln -s /lib $TARGET/lib/arm-linux-gnueabihf
fi

if ! [ -L $TARGET/usr/lib/arm-linux-gnueabihf ]; then
    ln -s /usr/lib $TARGET/usr/lib/arm-linux-gnueabihf
fi

