**************************
Freescale i.MX51 EVK board
**************************

This file documents the Buildroot support for the Freescale i.MX51 EVK board.

Build
=====

First, configure Buildroot for the i.MX51 EVK board:

  make mx51evk_defconfig

Build all components:

  make

You will find in output/images/ the following files:
  - imx51-babbage.dtb
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

Boot the i.MX51 EVK board
=========================

To boot your newly created system:
- insert the SD card in the SD slot of the board;
- put a micro USB cable into the Debug USB Port and connect using a terminal
  emulator at 115200 bps, 8n1;
- power on the board.

Enjoy!
