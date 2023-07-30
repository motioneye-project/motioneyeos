#!/bin/sh

set -e

RPI_FW_DIR=${TARGET}/../images/rpi-firmware

cp ${BOARD_DIR}/config.txt ${BOOT_DIR}
cp ${BOARD_DIR}/cmdline.txt ${BOOT_DIR}
cp ${BOARD_DIR}/initrd.gz ${BOOT_DIR}
cp ${BOARD_DIR}/wpa_supplicant.conf ${BOOT_DIR}
cp ${IMG_DIR}/zImage ${BOOT_DIR}/kernel.img
cp ${IMG_DIR}/bcm2711-rpi-4-b.dtb ${BOOT_DIR}
cp ${RPI_FW_DIR}/start.elf ${BOOT_DIR}
cp ${RPI_FW_DIR}/fixup.dat ${BOOT_DIR}

# copy overlays
mkdir -p ${BOOT_DIR}/overlays
cp ${RPI_FW_DIR}/overlays/*.dtbo ${BOOT_DIR}/overlays

# libfdt.so doesn't get installed automatically, for some reason
cp ${BUILD_DIR}/rpi-userland-*/build/lib/libfdt.so ${TARGET}/usr/lib
