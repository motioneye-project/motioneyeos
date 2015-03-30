*******************************************************
Freescale i.MX6Q and i.MX6DL SABRESD development boards
*******************************************************

This file documents the Buildroot support for the Freescale SABRE Board for
Smart Devices Based on the i.MX 6 Series (SABRESD), as well as the Freescale
SABRE Board for Automotive Infotainment.

Read the SABRESD Quick Start Guide for an introduction to the board:
http://cache.freescale.com/files/32bit/doc/quick_start_guide/SABRESDB_IMX6_QSG.pdf

Read the SABRE for Automotive Infotainment Quick Start Guide for an
introduction to the board:
http://cache.freescale.com/files/32bit/doc/user_guide/IMX6SABREINFOQSG.pdf

Build
=====

First, configure Buildroot for your SABRE board.
For i.MX6Q SABRE SD board:

  make freescale_imx6qsabresd_defconfig

For i.MX6DL SABRE SD board:

  make freescale_imx6dlsabresd_defconfig

For i.MX6Q SABRE Auto board:

  make freescale_imx6qsabreauto_defconfig

For i.MX6DL SABRE Auto board:

  make freescale_imx6dlsabreauto_defconfig

Build all components:

  make

You will find in ./output/images/ the following files:
  - imx6dl-sabresd.dtb or imx6q-sabresd.dtb or imx6q-sabreauto.dtb or
    imx6dl-sabreauto.dtb
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

  ./board/freescale/create-boot-sd.sh <your-sd-device>

Boot the SABRE board
====================

SABRE SD
--------

To boot your newly created system on a SABRE SD Board (refer to the SABRE SD
Quick Start Guide for guidance):
- insert the SD card in the SD3 slot of the board;
- locate the BOOT dip switches (SW6), set dips 2 and 7 to ON, all others to OFF;
- connect a Micro USB cable to Debug Port and connect using a terminal emulator
  at 115200 bps, 8n1;
- power on the board.

SABRE Auto
----------

To boot your newly created system on a SABRE Auto Board (refer to the SABRE for
Automotive Infotainment Quick Start Guide for guidance):
- insert the SD card in the CPU card SD card socket J14;
- Set the S1, S2 and S3 DIP switches and J3 jumper to boot from SD on CPU card.
  Reference configuration:

    S1
     1  2   3   4  5   6   7   8   9  10
    off ON off off ON off off off off off

    S2
     1   2  3   4
    off off ON off

    S3
     1   2  3  4
    off off ON ON

    J3: 1-2

- connect an RS-232 UART cable to CPU card debug port J18 UART DB9 and
  connect using a terminal emulator at 115200 bps, 8n1;
- power on the board.

Enjoy!

References
==========

https://community.freescale.com/docs/DOC-95015
https://community.freescale.com/docs/DOC-95017
https://community.freescale.com/docs/DOC-99218
