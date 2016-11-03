#!/bin/sh

BOARD_DIR="$(dirname $0)"
GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}"

echo --rootpath "${TARGET_DIR}"
echo --tmppath "${GENIMAGE_TMP}"
echo --inputpath "${BINARIES_DIR}"
echo --outputpath "${BINARIES_DIR}"
echo --config "${GENIMAGE_CFG}"

genimage                               \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"
