#!/bin/sh
# post-build fixups
# for further details, see
#
#  http://boundarydevices.com/u-boot-on-i-mx6/
#

BOARD_DIR="$(dirname $0)"

# bd u-boot looks for bootscript here
cp $BOARD_DIR/6x_bootscript $TARGET_DIR

# u-boot / update script for bd upgradeu command
if [ -e $BINARIES_DIR/u-boot.imx ];
then
    cp $BINARIES_DIR/u-boot.imx $TARGET_DIR
    cp $BOARD_DIR/6x_upgrade $TARGET_DIR
fi
