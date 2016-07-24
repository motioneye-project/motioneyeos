#!/bin/sh

BOARD_DIR="$(dirname $0)"
GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
OUTPUT_DIR="${O}/images"

rm -rf "${GENIMAGE_TMP}"

cp board/digilent/zybo/uEnv.txt ${BINARIES_DIR}
cp board/digilent/zybo/system.bit ${BINARIES_DIR}

genimage                               \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"
