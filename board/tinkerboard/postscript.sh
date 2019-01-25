#!/bin/sh

set -e

cp $IMG_DIR/zImage $BOOT_DIR
cp $IMG_DIR/rk3288-miniarm.dtb $BOOT_DIR
cp $BOARD_DIR/hw_intf.conf $BOOT_DIR
cp -r $BOARD_DIR/extlinux $BOOT_DIR

