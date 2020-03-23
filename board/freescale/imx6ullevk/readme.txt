****************************
Freescale i.MX6ULL EVK board
****************************

This file documents the Buildroot support for the Freescale i.MX6ULL EVK board.

Build
=====

First, configure Buildroot for your i.MX6ULL EVK board:

  make freescale_imx6ullevk_defconfig

Build all components:

  make

You will find in output/images/ the following files:
  - boot.vfat
  - imx6ull-14x14-evk.dtb
  - rootfs.ext2
  - rootfs.ext4
  - rootfs.tar
  - sdcard.img
  - u-boot.bin
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

  dd if=./output/images/sdcard.img of=/dev/<your-sd-device>

*** WARNING! This will destroy all the card content. Use with care! ***

For details about the medium image layout, see the definition in
board/freescale/common/imx/genimage.cfg.template.

Boot the i.MX6ULL EVK board
===========================

To boot your newly created system (refer to the i.MX 6ULL EVK Quick Start Guide [1] for guidance):
- insert the SD card in the micro SD slot of the board;
- put a micro USB cable into the Debug USB Port and connect using a terminal
  emulator at 115200 bps, 8n1;
- power on the board.

Enjoy!

References
==========
[1] https://www.nxp.com/files-static/32bit/doc/brochure/IMX6ULLQSG.pdf
