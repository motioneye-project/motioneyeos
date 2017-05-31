#!/bin/bash -e

BOARD_DIR=$(dirname $0)
COMMON_DIR=$BOARD_DIR/../common

export BOARD=$(basename $BOARD_DIR)
export IMG_DIR=$BOARD_DIR/../../output/$BOARD/images/
export UBOOT_BIN=$IMG_DIR/u-boot.bin
export UBOOT_SEEK=38192
BOOT0=$IMG_DIR/boot0.bin

source $COMMON_DIR/mkimage.sh

dd conv=notrunc if=$BOOT0 of=$DISK_IMG bs=1k seek=8 count=32 oflag=direct 

