*******************************
QMTECH Zynq XC7Z010 Starter Kit
*******************************

This file documents the Buildroot support for the QMTECH [1] Zynq
XC7Z010 Starter Kit [2]. It is a low cost (~55$) Zynq based
development board. The board user manual is available at
[3]. Additional files are available on Github [4].


Build
=====

First, configure Buildroot for the QMTECH Zynq board:

  make zynq_qmtech_defconfig

Build all components:

  make

You will find in output/images/ the following files:
  - boot.bin
  - boot.vfat
  - devicetree.dtb
  - rootfs.cpio
  - rootfs.cpio.gz
  - rootfs.cpio.uboot
  - rootfs.tar
  - sdcard.img
  - u-boot.bin
  - u-boot.img
  - uImage
  - zynq-qmtech.dtb


Create a bootable micro SD card
===============================

To determine the device associated to the micro SD card have a look in
the /proc/partitions file:

  cat /proc/partitions

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on a micro SD card. Launch the following
command as root:

  dd if=output/images/sdcard.img of=/dev/<your-sd-device>

*** WARNING! This will destroy all the card content. Use with care! ***


Boot the QMTECH Zynq board
==========================

To boot your newly created system:
- put a mini USB cable into the J4 Debug USB Port and connect using a
  terminal emulator at 115200 bps, 8n1,
- put the prepared micro SD card in the J2 micro SD card slot,
- plug the 5V power supply on the JP4 barrel jack.

Enjoy!


[1]. QMTECH:
     http://www.chinaqmtech.com/

[2]. QMTECH Zynq XC7Z010 Starter Kit Product Page:
     http://www.chinaqmtech.com/xilinx_zynq_soc

[3]. QMTECH Zynq XC7Z010 Starter Kit Hardware User Manual:
     http://www.chinaqmtech.com/filedownload/32552

[4]. QMTECH Github:
     https://github.com/ChinaQMTECH/ZYNQ_STARTER_KIT
