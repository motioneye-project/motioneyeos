#!/bin/sh
# post-image.sh for SoCkit
# 2014, "Roman Diouskine" <roman.diouskine@savoirfairelinux.com>
# 2014, "Sebastien Bourdelin" <sebastien.bourdelin@savoirfairelinux.com>

# create a DTB file copy with the name expected by the u-boot config
cp -af $BINARIES_DIR/socfpga_cyclone5_sockit.dtb  $BINARIES_DIR/socfpga.dtb
