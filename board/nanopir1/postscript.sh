#!/bin/sh

set -e

${HOST_DIR}/bin/mkimage -C none -A arm -T script -d ${BOARD_DIR}/boot.cmd ${BOOT_DIR}/boot.scr

cp ${IMG_DIR}/zImage ${BOOT_DIR}
cp ${IMG_DIR}/sun8i-h3-nanopi-r1.dtb ${BOOT_DIR}
cp ${BOARD_DIR}/uInitrd ${BOOT_DIR}
cp ${BOARD_DIR}/uEnv.txt ${BOOT_DIR}
