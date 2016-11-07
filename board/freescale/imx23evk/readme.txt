**************************
Freescale i.MX23 EVK board
**************************

This file documents the Buildroot support for the Freescale i.MX23 EVK board.

Build
=====

First, configure Buildroot for your i.MX23 EVK board:

  make imx23evk_defconfig

Build all components:

  make

You will find in output/images/ directory the following files:
  - imx23-evk.dtb
  - rootfs.tar
  - u-boot.sd
  - zImage

Create a bootable SD card
=========================

To determine the device associated to the SD card have a look in the
/proc/partitions file:

  cat /proc/partitions

Then, run the following command:

*** WARNING! The command will destroy all the card content. Use with care! ***

 sudo dd if=output/images/sdcard.img of=/dev/<your-microsd-device>

Boot the i.MX23 EVK board
=========================

- Put the Boot Mode Select jumper as 1 0 0 1 so that it can boot
  from the SD card
- Insert the SD card in the SD Card slot of the board;
- Connect an RS232 UART cable to the Debug UART Port and connect using a
  terminal emulator at 115200 bps, 8n1;
- power on the board.

Enjoy!
