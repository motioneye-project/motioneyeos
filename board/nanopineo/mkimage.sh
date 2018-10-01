#!/bin/bash -e

BOARD_DIR=$(dirname $0)
COMMON_DIR=$BOARD_DIR/../common

export BOARD=$(basename $BOARD_DIR)
export IMG_DIR=$BOARD_DIR/../../output/$BOARD/images/
export UBOOT_BIN=$BOARD_DIR/u-boot-with-spl.bin
export UBOOT_SEEK=16
export PART_START=40960
source $COMMON_DIR/mkimage.sh


