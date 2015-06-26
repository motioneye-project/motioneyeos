#!/bin/sh
# args from BR2_ROOTFS_POST_SCRIPT_ARGS
# $2    path of boot.cmd
# $3    output directory for boot.scr

MKIMAGE=$HOST_DIR/usr/bin/mkimage

$MKIMAGE -A arm -O linux -T script -C none -d $2 $3/boot.scr
