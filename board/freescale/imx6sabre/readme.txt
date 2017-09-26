********************************************************
Freescale i.MX6 Q, DL and SoloX SABRE development boards
********************************************************

This file documents the Buildroot support for the Freescale SABRE Board
for Smart Devices Based on the i.MX 6 and i.MX 6SoloX Series (SABRESD),
as well as the Freescale SABRE Board for Automotive Infotainment.

Read the i.MX 6 SABRESD Quick Start Guide for an introduction to the
board:
http://cache.freescale.com/files/32bit/doc/quick_start_guide/SABRESDB_IMX6_QSG.pdf

Read the i.MX 6 SoloX SABRESD Quick Start Guide for an introduction to
the board:
http://cache.freescale.com/files/32bit/doc/user_guide/IMX6SOLOXQSG.pdf

Read the SABRE for Automotive Infotainment Quick Start Guide for an
introduction to the board:
http://cache.freescale.com/files/32bit/doc/user_guide/IMX6SABREINFOQSG.pdf

Building with NXP kernel and NXP U-Boot
=======================================

First, configure Buildroot for your SABRE board.
For i.MX6Q SABRE SD board:

  make freescale_imx6qsabresd_defconfig

For i.MX6DL SABRE SD board:

  make freescale_imx6dlsabresd_defconfig

For i.MX6 SoloX SABRE SD board:

  make freescale_imx6sxsabresd_defconfig

For i.MX6Q SABRE Auto board:

  make freescale_imx6qsabreauto_defconfig

For i.MX6DL SABRE Auto board:

  make freescale_imx6dlsabreauto_defconfig

Build all components:

  make

You will find in ./output/images/ the following files:
  - imx6dl-sabresd.dtb or imx6q-sabresd.dtb or imx6sx-sdb.dtb or
    imx6q-sabreauto.dtb or imx6dl-sabreauto.dtb
  - rootfs.ext2
  - rootfs.tar
  - u-boot.imx
  - uImage, or zImage for i.MX6 SoloX

Building with mainline kernel and mainline U-Boot
=================================================

Mainline U-Boot uses SPL and can support the three
variants of mx6sabreauto boards: mx6q, mx6dl and mx6qp.

First, configure Buildroot for your mx6sabreauto board

  make imx6-sabreauto_defconfig

Build all components:

  make

You will find in output/images/ the following files:
  - imx6dl-sabresd.dtb, imx6q-sabresd.dtb, imx6q-sabresd.dtb
  - rootfs.ext2
  - SPL and u-boot.img
  - u-boot.imx
  - zImage

Create a bootable SD card
=========================

To determine the device associated to the SD card have a look in the
/proc/partitions file:

  cat /proc/partitions

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on a microSD card. Launch the following
command as root:

  dd if=./output/images/sdcard.img of=/dev/<your-microsd-device>

*** WARNING! The script will destroy all the card content. Use with care! ***

For details about the medium image layout, see the definition in
board/freescale/common/imx/genimage.cfg.template.

Boot the SABRE board
====================

i.MX6 SABRE SD
--------------

To boot your newly created system on an i.MX6 SABRE SD Board (refer to
the i.MX6 SABRE SD Quick Start Guide for guidance):
- insert the SD card in the SD3 slot of the board;
- locate the BOOT dip switches (SW6), set dips 2 and 7 to ON, all others to OFF;
- connect a Micro USB cable to Debug Port and connect using a terminal emulator
  at 115200 bps, 8n1;
- power on the board.

i.MX6 SoloX SABRE SD
--------------------

To boot your newly created system on an i.MX6 SoloX SABRE SD Board
(refer to the i.MX6 SoloX SABRE SD Quick Start Guide for guidance):
- insert the SD card in the J4-SD4 socket at the bottom of the board;
- Set the SW10, SW11 and SW12 DIP switches at the top of the board in
  their default position, to boot from SD card. Reference configuration:

    SW10
     1   2   3   4   5   6   7   8
    off off off off off off off off

    SW11
     1   2  3  4  5   6   7   8
    off off ON ON ON off off off

    SW12
     1  2   3   4   5   6   7   8
    off ON off off off off off off

- connect a Micro USB cable to the J16 Debug Port at the bottom of the
  board. This is a dual UART debug port; connect to the first tty using
  a terminal emulator at 115200 bps, 8n1;
- power on the board with the SW1-PWR switch at the top of the board.

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
