#!/bin/sh

set -e

# boot directory
mkdir -p ${BOOT_DIR}

cp ${BOARD_DIR}/bl1.bin.hardkernel ${IMG_DIR}
cp ${BOARD_DIR}/bl2.bin.hardkernel ${IMG_DIR}
cp ${BOARD_DIR}/tzsw.bin.hardkernel ${IMG_DIR}
cp ${BOARD_DIR}/u-boot.bin ${IMG_DIR}

cp ${IMG_DIR}/zImage ${BOOT_DIR}
cp ${IMG_DIR}/exynos5422-odroidxu4.dtb ${BOOT_DIR}
cp ${BOARD_DIR}/boot.ini ${BOOT_DIR}
cp ${BOARD_DIR}/uInitrd ${BOOT_DIR}

sed -i '/^ttylogin::respawn:\/sbin\/getty -L ttylogin 115200 vt100/a\ttylogin::respawn:\/sbin\/getty -L ttySAC2 115200 vt100'  ${TARGET}/etc/inittab
