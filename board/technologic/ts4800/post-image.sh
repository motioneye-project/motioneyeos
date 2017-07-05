#!/bin/bash
#
# Copyright (C) 2015 Savoir-faire Linux
# Post image generation script.

BOARD_DIR="$(dirname $0)"
GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP=${BUILD_DIR}/.genimage_tmp

rm -rf ${GENIMAGE_TMP}

${HOST_DIR}/bin/genimage \
        --config ${GENIMAGE_CFG} \
        --rootpath ${TARGET_DIR} \
        --tmppath ${GENIMAGE_TMP} \
        --inputpath $BINARIES_DIR \
        --outputpath $BINARIES_DIR

exit $?
