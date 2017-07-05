#!/bin/sh

BOARD_DIR="$(dirname $0)"
MKIMAGE=$HOST_DIR/bin/mkimage

$MKIMAGE -C none -A arm64 -T script -d $BOARD_DIR/boot.txt $BINARIES_DIR/boot.scr

# vendor u-boot uses uImage
if [ -e $BINARIES_DIR/Image ]; then
    $MKIMAGE -A arm64 -O linux -T kernel -C none -a 0x1080000 -e 0x1080000 \
	     -n linux -d $BINARIES_DIR/Image $BINARIES_DIR/uImage
fi
