#!/bin/sh
# post-build fixups
# for further details, see
#
#  http://boundarydevices.com/u-boot-on-i-mx6/
#

BOARD_DIR="$(dirname $0)"
UBOOT_DEFCONFIG="$(grep BR2_TARGET_UBOOT_BOARD_DEFCONFIG ${BR2_CONFIG} | sed 's/.*\"\(.*\)\"/\1/')"

if grep -Eq "^BR2_aarch64=y$" ${BR2_CONFIG}; then
	MKIMAGE_ARCH=arm64
	UBOOT_BINARY=imx8-boot-sd.bin
else
	MKIMAGE_ARCH=arm
	UBOOT_BINARY=u-boot.imx
fi

# bd u-boot looks for standard bootscript
$HOST_DIR/bin/mkimage -A $MKIMAGE_ARCH -O linux -T script -C none -a 0 -e 0 \
    -n "boot script" -d $BOARD_DIR/boot.cmd $TARGET_DIR/boot/boot.scr

# u-boot / update script for bd upgradeu command
if [ -e $BINARIES_DIR/$UBOOT_BINARY ]; then
    install -D -m 0644 $BINARIES_DIR/$UBOOT_BINARY \
        $TARGET_DIR/u-boot.$UBOOT_DEFCONFIG
    $HOST_DIR/bin/mkimage -A $MKIMAGE_ARCH -O linux -T script -C none -a 0 -e 0 \
        -n "upgrade script" -d $BOARD_DIR/upgrade.cmd $TARGET_DIR/upgrade.scr
fi
