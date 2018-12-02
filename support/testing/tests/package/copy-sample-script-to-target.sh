#!/bin/sh
set -e

shift
for file in "$@"; do
	cp -f "${file}" "${TARGET_DIR}/root/"
done
