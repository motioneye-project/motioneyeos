#!/bin/sh

BOARD_DIR="$(dirname $0)"
GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

cp ${BOARD_DIR}/boot.ini ${BINARIES_DIR}/

# The bl1.bin.hardkernel file provided by the uboot hardkernel repository is overwritten
# by the bl2.bin.hardkernel in the sd_fusing.sh script because it is too big.
# In order to implement this in genimage, we need to truncate the bl1.bin file
# so that it does not exceed the available place.
# An issue has been filled about this: https://github.com/hardkernel/u-boot/issues/45
truncate -s 15360 ${BINARIES_DIR}/bl1.bin.hardkernel

rm -rf "${GENIMAGE_TMP}"

genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

