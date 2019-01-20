#!/bin/sh

set -e

# boot directory
mkdir -p ${BOOT_DIR}/pine64

cp ${IMG_DIR}/Image ${BOOT_DIR}/kernel.img
cp ${BOARD_DIR}/uEnv.txt ${BOOT_DIR}
cp ${BOARD_DIR}/dtb/* ${BOOT_DIR}/pine64
cp ${BOARD_DIR}/fwupdater.img ${BOOT_DIR}

