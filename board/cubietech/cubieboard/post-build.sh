#!/bin/sh
# post-build.sh for CubieBoard
# 2013, Carlo Caione <carlo.caione@gmail.com>

BOARD_DIR="$(dirname $0)"
MKIMAGE=$HOST_DIR/usr/bin/mkimage
BOOT_CMD=$BOARD_DIR/boot.cmd
BOOT_CMD_H=$BINARIES_DIR/boot.scr

# U-Boot script
if [ -e $MKIMAGE -a -e $BOOT_CMD ];
then
	$MKIMAGE -C none -A arm -T script -d $BOOT_CMD $BOOT_CMD_H
fi
