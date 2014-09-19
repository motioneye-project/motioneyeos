*******************************************************
Freescale i.MX6Q and i.MX6DL SABRESD development boards
*******************************************************

This file documents the Buildroot support for the Freescale SABRE Board for
Smart Devices Based on the i.MX 6 Series (SABRESD).

Read the SABRESD Quick Start Guide for an introduction to the board:
http://cache.freescale.com/files/32bit/doc/quick_start_guide/SABRESDB_IMX6_QSG.pdf

Build
=====

First, configure Buildroot for your SABRESD board.
For i.MX6Q:

  make freescale_imx6qsabresd_defconfig

For i.MX6DL:

  make freescale_imx6dlsabresd_defconfig

Build all components:

  make

You will find in ./output/images/ the following files:
  - imx6dl-sabresd.dtb or imx6q-sabresd.dtb
  - rootfs.ext2
  - rootfs.tar
  - u-boot.imx
  - uImage

Create a bootable SD card
=========================

To determine the device associated to the SD card have a look in the
/proc/partitions file:

  cat /proc/partitions

Run the following script as root on your SD card. This will partition the card
and copy the bootloader, kernel, DTBs and root filesystem as needed.

*** WARNING! The script will destroy all the card content. Use with care! ***

  ./board/freescale/imx6sabresd/create-boot-sd.sh <your-sd-device>

Boot the SABRESD board
======================

To boot your newly created system (refer to the SABRESD Quick Start Guide for
guidance):
- insert the SD card in the SD3 slot of the board;
- locate the BOOT dip switches (SW6), set dips 2 and 7 to ON, all others to OFF;
- connect a Micro USB cable to Debug Port and connect using a terminal emulator
  at 115200 bps, 8n1;
- power on the board.

Enjoy!

References
==========

https://community.freescale.com/docs/DOC-95015
https://community.freescale.com/docs/DOC-95017
https://community.freescale.com/docs/DOC-99218
