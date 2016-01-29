***************************
Freescale i.MX6UL EVK board
***************************

This file documents the Buildroot support for the Freescale i.MX6UL EVK board.

Please read the i.MX6UL Evaluation Kit Quick Start Guide [1] for an
introduction to the board.

Build
=====

First, configure Buildroot for your i.MX6UL EVK board:

  make freescale_imx6ulevk_defconfig

Build all components:

  make

You will find in ./output/images/ the following files:
  - imx6ul-14x14-evk.dtb
  - rootfs.ext2
  - rootfs.tar
  - sdcard.img
  - u-boot.imx
  - zImage

Create a bootable microSD card
==============================

To determine the device associated to the microSD card have a look in the
/proc/partitions file:

  cat /proc/partitions

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on a microSD card. Launch the following
command as root:

  dd if=./output/images/sdcard.img of=/dev/<your-microsd-device>

*** WARNING! This will destroy all the card content. Use with care! ***

For details about the medium image layout, see the definition in
board/freescale/imx6ulevk/genimage.cfg.

Boot the i.MX6UL EVK board
=========================

To boot your newly created system (refer to the i.MX6UL EVK Quick Start Guide
[1] for guidance):
- insert the microSD card in the microSD slot of the board;
- verify that your i.MX6UL EVK board jumpers and switches are set as mentioned
  in the i.MX6UL EVK Quick Start Guide [1];
- put a micro USB cable into the Debug USB Port and connect using a terminal
  emulator at 115200 bps, 8n1;
- power on the board.

Enjoy!

References
==========
[1] http://cache.freescale.com/files/32bit/doc/quick_start_guide/IMX6ULTRALITEQSG.pdf
