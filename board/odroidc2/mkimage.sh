#!/bin/bash -e

BOARD_DIR=$(dirname $0)
COMMON_DIR=${BOARD_DIR}/../common

export BOARD=$(basename ${BOARD_DIR})
export IMG_DIR=${BOARD_DIR}/../../output/${BOARD}/images/
export UBOOT_BIN=${IMG_DIR}/u-boot.bin
export UBOOT_SEEK=97

source ${COMMON_DIR}/mkimage.sh

dd conv=notrunc if=${UBOOT_BIN} of=${DISK_IMG} bs=1 count=442
dd conv=notrunc if=${UBOOT_BIN} of=${DISK_IMG} bs=512 skip=1 seek=1
