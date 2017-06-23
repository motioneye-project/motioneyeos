********************************************
Buildroot for Engicam GEAM6UL SOM platforms:
********************************************

This file documents the Buildroot support for all Engicam GEAM6UL
SOM platform boards.

GEAM6UL SOM Starter kits:
https://www.engicam.com/vis-prod/101115

This configuration uses U-Boot mainline and kernel mainline.

Build
=====

First, configure Buildroot for the Engicam GEAM6UL SOM:

- for GEAM6UL SOM:

  make engicam_imx6ul_geam_defconfig

Build all components:

  make

You will find the following files in output/images/:
  - imx6ul-geam-kit.dtb
  - rootfs.ext4
  - rootfs.tar
  - sdcard.img
  - SPL
  - u-boot-dtb.img
  - uImage

Create a bootable SD card
=========================

To determine the device associated to the SD card have a look in the
/proc/partitions file:

  cat /proc/partitions

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on a SD card. Launch the following
command as root:

  dd if=output/images/sdcard.img of=/dev/<your-sd-device>
  sync

*** WARNING! This will destroy all the card content. Use with care! ***

For details about the medium image layout, see the definition in
board/engicam/geam6ul/genimage.cfg

Boot the GEAM6UL boards with SD boot:
====================================

To boot your newly created system:
- insert the SD card in the SD slot of the board;
- connect 3-wire RS232 serial port J28 on board, and connect with other
  serial end or USB cable(if serial-to-usb converter used) using
  a terminal emulator at 115200 bps, 8n1;
- close JM3 for sd boot.
- power on the board.

Enjoy!
