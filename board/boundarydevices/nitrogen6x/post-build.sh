#!/bin/sh
# post-build fixups
# for further details, see
#
#  http://boundarydevices.com/u-boot-on-i-mx6/
#

BOARD_DIR="$(dirname $0)"

# bd u-boot looks for bootscript here
install -D -m 0644 $BOARD_DIR/6x_bootscript $TARGET_DIR/6x_bootscript

# u-boot / update script for bd upgradeu command
if [ -e $BINARIES_DIR/u-boot.imx ];
then
    install -D -m 0644 $BINARIES_DIR/u-boot.imx $TARGET_DIR/u-boot.imx
    install -D -m 0644 $BOARD_DIR/6x_upgrade $TARGET_DIR/6x_upgrade
fi
