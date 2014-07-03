#!/bin/sh

TARGET_DIR=$1
BOARD_DIR="$(dirname $0)"

mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "boot script" \
    -d $BOARD_DIR/6q_bootscript.txt $TARGET_DIR/6q_bootscript
