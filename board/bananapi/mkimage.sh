#!/bin/bash -e

BOARD_DIR=$(dirname $0)
COMMON_DIR=$BOARD_DIR/../common

export BOARD=$(basename $BOARD_DIR)
export IMG_DIR=$BOARD_DIR/../../output/$BOARD/images/
export UBOOT_BIN=$IMG_DIR/u-boot-sunxi-with-spl.bin
export UBOOT_SEEK=16

$COMMON_DIR/mkimage.sh

