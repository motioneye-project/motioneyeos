#!/bin/bash

die() {
  echo "Error: $@" >&2
  exit 1
}

GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

while getopts c: OPT ; do
	case "${OPT}" in
	c) GENIMAGE_CFG="${OPTARG}";;
	:) die "option '${OPTARG}' expects a mandatory argument\n";;
	\?) die "unknown option '${OPTARG}'\n";;
	esac
done

[ -n "${GENIMAGE_CFG}" ] || die "Missing argument"

rm -rf "${GENIMAGE_TMP}"

genimage \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"
