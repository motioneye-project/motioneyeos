*******************************
Freescale i.MX6Q Sabre SD board
*******************************

This file documents the Buildroot support for the Freescale i.MX6Q Sabre SD
board.

This configuration uses U-Boot mainline and kernel mainline.

Build
=====

First, configure Buildroot for the i.MX6Q Sabre SD board:

  make imx6q-sabresd_defconfig

Build all components:

  make

You will find the following files in output/images/ :
  - imx6q-sabresd.dtb
  - rootfs.ext4
  - rootfs.tar
  - sdcard.img
  - u-boot.imx
  - zImage

Create a bootable SD card
=========================

To determine the device associated to the SD card have a look in the
/proc/partitions file:

  cat /proc/partitions

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on a SD card. Launch the following
command as root:

  dd if=output/images/sdcard.img of=/dev/<your-sd-device>

*** WARNING! This will destroy all the card content. Use with care! ***

For details about the medium image layout, see the definition in
board/freescale/common/imx/genimage.cfg.template.

Boot the i.MX6Q Sabre SD board
==============================

To boot your newly created system:
- insert the SD card in the SD3 slot of the board (close to the HDMI connector);
- put a micro USB cable into the Debug USB Port and connect using a terminal
  emulator at 115200 bps, 8n1;
- power on the board.

Testing graphics on the i.MX6Q Sabre SD board
=============================================

The imx6q-sabresd_qt5_defconfig allows to quickly test the graphics
capabilities of i.MX6 using the opensource Etnaviv graphics stack
and kernel mainline.

In order to build it:

make imx6q-sabresd_qt5_defconfig
make

Then flash the SD card as explained above.

Running kmscube application:

# kmscube -D /dev/dri/card1

Running Qt5 Cinematic Demo:

# export QT_QPA_EGLFS_KMS_CONFIG=/root/sabresd.json
# /usr/share/Qt5/CinematicExperience/Qt5_CinematicExperience

Enjoy!
