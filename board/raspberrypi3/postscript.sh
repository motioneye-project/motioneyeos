#!/bin/sh

set -e

RPI_FW_DIR=${TARGET}/../images/rpi-firmware

cp ${BOARD_DIR}/config.txt ${BOOT_DIR}
cp ${BOARD_DIR}/cmdline.txt ${BOOT_DIR}
cp ${BOARD_DIR}/fwupdater.gz ${BOOT_DIR}
cp ${BOARD_DIR}/initrd.gz ${BOOT_DIR}
cp ${IMG_DIR}/zImage ${BOOT_DIR}/kernel.img
cp ${IMG_DIR}/bcm2710-rpi-3-b.dtb ${BOOT_DIR}
cp ${IMG_DIR}/bcm2710-rpi-3-b-plus.dtb ${BOOT_DIR}
cp ${IMG_DIR}/bcm2710-rpi-cm3.dtb ${BOOT_DIR}
cp ${IMG_DIR}/bcm2710-rpi-zero-2.dtb ${BOOT_DIR}
cp ${RPI_FW_DIR}/bootcode.bin ${BOOT_DIR}
cp ${RPI_FW_DIR}/start.elf ${BOOT_DIR}
cp ${RPI_FW_DIR}/fixup.dat ${BOOT_DIR}

# copy overlays
mkdir -p ${BOOT_DIR}/overlays
cp ${RPI_FW_DIR}/overlays/*.dtbo ${BOOT_DIR}/overlays

# libfdt.so doesn't get installed automatically, for some reason
cp ${BUILD_DIR}/rpi-userland-*/build/lib/libfdt.so ${TARGET}/usr/lib
