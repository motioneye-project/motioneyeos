#!/bin/sh
# args from BR2_ROOTFS_POST_SCRIPT_ARGS
# $2    board name

cp -v board/minnowboard/grub-${2}.cfg ${BINARIES_DIR}/efi-part/EFI/BOOT/grub.cfg
