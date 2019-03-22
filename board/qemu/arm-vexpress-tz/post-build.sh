#!/bin/sh

set -u
set -e

# Rename boot images for the dear TF-A
ln -sf u-boot.bin ${BINARIES_DIR}/bl33.bin
ln -sf tee-header_v2.bin ${BINARIES_DIR}/bl32.bin
ln -sf tee-pager_v2.bin ${BINARIES_DIR}/bl32_extra1.bin
ln -sf tee-pageable_v2.bin ${BINARIES_DIR}/bl32_extra2.bin
