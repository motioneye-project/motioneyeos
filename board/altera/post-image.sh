#!/bin/sh
# post-image.sh for SoCkit/SoCDK
# 2014, "Roman Diouskine" <roman.diouskine@savoirfairelinux.com>
# 2014, "Sebastien Bourdelin" <sebastien.bourdelin@savoirfairelinux.com>

# create a DTB file copy with the name expected by the u-boot config
# Name of the DTB is passed as the second argument to the script.
cp -af $BINARIES_DIR/${2}.dtb  $BINARIES_DIR/socfpga.dtb
