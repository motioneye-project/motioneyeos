#!/bin/sh
# post-build fixups
# for further details, see
#
#  http://boundarydevices.com/u-boot-on-i-mx6/
#

BOARD_DIR="$(dirname $0)"
UBOOT_DEFCONFIG="$(grep BR2_TARGET_UBOOT_BOARD_DEFCONFIG ${BR2_CONFIG} | sed 's/.*\"\(.*\)\"/\1/')"

# bd u-boot looks for standard bootscript
install -m 0644 -D $BINARIES_DIR/boot.scr $TARGET_DIR/boot/

# u-boot / update script for bd upgradeu command
if [ -e $BINARIES_DIR/u-boot.imx ]; then
    install -D -m 0644 $BINARIES_DIR/u-boot.imx \
        $TARGET_DIR/u-boot.$UBOOT_DEFCONFIG
    $HOST_DIR/bin/mkimage -A arm -O linux -T script -C none -a 0 -e 0 \
    -n "upgrade script" -d $BOARD_DIR/upgrade.cmd $TARGET_DIR/upgrade.scr
fi
