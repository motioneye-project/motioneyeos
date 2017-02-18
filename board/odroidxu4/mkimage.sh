#!/bin/bash -e

BOARD_DIR=$(dirname $0)
COMMON_DIR=$BOARD_DIR/../common

export BOARD=$(basename $BOARD_DIR)
export IMG_DIR=$BOARD_DIR/../../output/$BOARD/images/
export UBOOT_BIN=$IMG_DIR/u-boot.bin
export UBOOT_SEEK=63
BL1=$IMG_DIR/bl1.bin.hardkernel
BL2=$IMG_DIR/bl2.bin.hardkernel
TZSW=$IMG_DIR/tzsw.bin.hardkernel
source $COMMON_DIR/mkimage.sh

dd conv=notrunc if=$BL1 of=$DISK_IMG bs=512 seek=1
dd conv=notrunc if=$BL2 of=$DISK_IMG bs=512 seek=31
dd conv=notrunc if=$TZSW of=$DISK_IMG bs=512 seek=719
dd conv=notrunc if=/dev/zero of=$DISK_IMG bs=512 seek=1231 count=32

