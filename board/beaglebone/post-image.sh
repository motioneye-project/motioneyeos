#!/bin/sh
# post-image.sh for BeagleBone
# 2014, Marcin Jabrzyk <marcin.jabrzyk@gmail.com>

# copy the uEnv.txt to the output/images directory
cp board/beaglebone/uEnv.txt $BINARIES_DIR/uEnv.txt
