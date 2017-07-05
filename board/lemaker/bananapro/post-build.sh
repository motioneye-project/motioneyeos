#!/bin/sh

# Remove all but the brcmfmac43362 firmware files
find $TARGET_DIR/lib/firmware/brcm -type f -not -name "brcmfmac43362*" -delete

BOARD_DIR="$(dirname $0)"
MKIMAGE=$HOST_DIR/bin/mkimage
BOOT_CMD=$BOARD_DIR/boot.cmd
BOOT_CMD_H=$BINARIES_DIR/boot.scr

# U-Boot script
$MKIMAGE -C none -A arm -T script -d $BOOT_CMD $BOOT_CMD_H
