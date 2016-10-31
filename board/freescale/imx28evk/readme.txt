**************************
Freescale i.MX28 EVK board
**************************

This file documents the Buildroot support for the Freescale i.MX28 EVK board.

Read the i.MX28 Evaluation Kit Quick Start Guide [1] for an introduction to the
board.

Build
=====

First, configure Buildroot for your i.MX28 EVK board:

  make freescale_imx28evk_defconfig

Build all components:

  make

You will find in ./output/images/ the following files:
  - imx28-evk.dtb
  - rootfs.tar
  - u-boot.sd
  - zImage

Create a bootable SD card
=========================

To determine the device associated to the SD card have a look in the
/proc/partitions file:

  cat /proc/partitions

Then, run the following command as root:

*** WARNING! The command will destroy all the card content. Use with care! ***

 sudo dd if=output/images/sdcard.img of=/dev/<your-microsd-device>

Boot the i.MX28 EVK board
=========================

To boot your newly created system (refer to the i.MX28 EVK Quick Start Guide
[1] for guidance):
- insert the SD card in the SD Card Socket 0 of the board;
- verify that your i.MX28 EVK board jumpers and switches are set as mentioned
  in the i.MX28 EVK Quick Start Guide [1];
- connect an RS232 UART cable to the Debug UART Port and connect using a
  terminal emulator at 115200 bps, 8n1;
- power on the board.

Enjoy!

References
==========
[1] http://cache.freescale.com/files/32bit/doc/user_guide/EVK_imx28_QuickStart.pdf
