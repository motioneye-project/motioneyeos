#!/bin/sh

MKIMAGE=$HOST_DIR/bin/mkimage
BOARD_DIR="$(dirname $0)"

$MKIMAGE -n rk3399 -T rksd -d $BINARIES_DIR/u-boot-tpl-dtb.bin $BINARIES_DIR/u-boot-tpl-dtb.img
cat $BINARIES_DIR/u-boot-tpl-dtb.img $BINARIES_DIR/u-boot-spl-dtb.bin > $BINARIES_DIR/u-boot-tpl-spl-dtb.img

install -m 0644 -D $BOARD_DIR/extlinux.conf $TARGET_DIR/boot/extlinux/extlinux.conf
