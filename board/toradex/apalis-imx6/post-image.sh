#!/usr/bin/env bash

GENIMAGE_CFG="$(dirname $0)/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

# copy the uEnv.txt to the output/images directory
cp board/toradex/apalis-imx6/uEnv.txt $BINARIES_DIR/uEnv.txt

rm -rf "${GENIMAGE_TMP}"

# generate rootfs.img
genimage \
  --rootpath "${TARGET_DIR}" \
  --tmppath "${GENIMAGE_TMP}" \
  --inputpath "${BINARIES_DIR}" \
  --outputpath "${BINARIES_DIR}" \
  --config "${GENIMAGE_CFG}"

RET=${?}
exit ${RET}
