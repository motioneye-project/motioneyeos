#!/bin/sh
# post-build fixups
# for furthe details, see
# http://boundarydevices.com/u-boot-conventions-for-i-mx6-nitrogen6x-and-sabrelite/

TARGET_DIR=$1
IMAGES_DIR=$1/../images
BOARD_DIR="$(dirname $0)"

# bd u-boot looks for bootscript here
cp $BOARD_DIR/6q_bootscript $TARGET_DIR

# u-boot / update script for bd upgradeu command
if [ -e $IMAGES_DIR/u-boot.bin ];
then
    cp $IMAGES_DIR/u-boot.bin $TARGET_DIR
    cp $BOARD_DIR/6q_upgrade $TARGET_DIR
fi
