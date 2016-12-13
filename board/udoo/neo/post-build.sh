#!/bin/sh

BOARD_DIR="$(dirname $0)"

$HOST_DIR/usr/bin/mkimage -A arm -O linux -T script -C none  \
-n "boot script" -d $BOARD_DIR/boot.scr.txt $BOARD_DIR/boot.scr

install -m 0644 -D $BOARD_DIR/boot.scr $TARGET_DIR/boot/boot.scr
