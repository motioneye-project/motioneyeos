#!/bin/sh

BOARD_DIR="$(dirname $0)"

install -d -m 755 $TARGET_DIR/boot
$HOST_DIR/bin/mkimage -A arm -O linux -T script -C none  \
	-n "boot script" -d $BOARD_DIR/boot.scr.txt $TARGET_DIR/boot/boot.scr
