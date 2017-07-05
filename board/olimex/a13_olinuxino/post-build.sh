#!/bin/sh

MKIMAGE=$HOST_DIR/bin/mkimage

$MKIMAGE -A arm -O linux -T script -C none \
	 -d board/olimex/a13_olinuxino/boot.cmd \
	 ${BINARIES_DIR}/boot.scr
