#!/bin/sh
# post-image.sh for CircuitCo BeagleBone and TI am335x-evm
# 2014, Marcin Jabrzyk <marcin.jabrzyk@gmail.com>
# 2016, Lothar Felten <lothar.felten@gmail.com>

BOARD_DIR="$(dirname $0)"

# copy the uEnv.txt to the output/images directory
cp board/beaglebone/uEnv.txt $BINARIES_DIR/uEnv.txt

# the 4.1 kernel does not provide a dtb for beaglebone green, so we
# use a different genimage config if am335x-bonegreen.dtb is not
# built:
if [ -e ${BINARIES_DIR}/am335x-bonegreen.dtb ] ; then
	GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
else
	GENIMAGE_CFG="${BOARD_DIR}/genimage_linux41.cfg"
fi

GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}"

genimage \
    --rootpath "${TARGET_DIR}" \
    --tmppath "${GENIMAGE_TMP}" \
    --inputpath "${BINARIES_DIR}" \
    --outputpath "${BINARIES_DIR}" \
    --config "${GENIMAGE_CFG}"
