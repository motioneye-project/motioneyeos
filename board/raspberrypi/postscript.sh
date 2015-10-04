#!/bin/sh

RPI_FW_DIR=$TARGET/../images/rpi-firmware

# copy System.map
cp $TARGET/../build/linux-*/System.map $TARGET/System.map

cp $BOARD_DIR/config.txt $BOOT_DIR
cp $BOARD_DIR/cmdline.txt $BOOT_DIR
cp $BOARD_DIR/fwupdater.gz $BOOT_DIR
cp $IMG_DIR/zImage $BOOT_DIR/kernel.img
cp $RPI_FW_DIR/bootcode.bin $BOOT_DIR
cp $RPI_FW_DIR/start.elf $BOOT_DIR
cp $RPI_FW_DIR/fixup.dat $BOOT_DIR

