#!/bin/sh

BOARD_DIR="$(dirname $0)"
GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}"

# As we now use the Linux v4.5-RC1 kernel no orangepi-pc dtb exists yet.
# However the orangepi-plus dtb has not much content, only mmc0 and uart
# which are equal to the pc version of the board, so we use it here.
mv ${BINARIES_DIR}/sun8i-h3-orangepi-plus.dtb ${BINARIES_DIR}/sun8i-h3-orangepi-pc.dtb


genimage                               \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
