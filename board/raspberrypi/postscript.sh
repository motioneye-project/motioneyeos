#!/bin/sh

set -e

RPI_FW_DIR=$TARGET/../images/rpi-firmware

cp $BOARD_DIR/config.txt $BOOT_DIR
cp $BOARD_DIR/cmdline.txt $BOOT_DIR
cp $BOARD_DIR/fwupdater.gz $BOOT_DIR
cp $IMG_DIR/zImage $BOOT_DIR/kernel.img
cp $IMG_DIR/bcm2708-rpi-b.dtb $BOOT_DIR
cp $IMG_DIR/bcm2708-rpi-b-plus.dtb $BOOT_DIR
cp $IMG_DIR/bcm2708-rpi-cm.dtb $BOOT_DIR
cp $IMG_DIR/bcm2708-rpi-0-w.dtb $BOOT_DIR
cp $RPI_FW_DIR/bootcode.bin $BOOT_DIR
cp $RPI_FW_DIR/start.elf $BOOT_DIR
cp $RPI_FW_DIR/fixup.dat $BOOT_DIR

