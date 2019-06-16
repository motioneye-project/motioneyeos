Intro
=====

The default configuration described below will allow you to start
experimenting with the buildroot environment for the SolidRun Clearfog GT-8K
based on the Marvell Armada 8040 SoC.

This default configuration will bring up the board and allow shell command
line access through the serial console.

How to build
============

  $ make solidrun_clearfog_gt_8k_defconfig
  $ make

How to write the SD card
========================

Once the build process is finished you will have an image file named
"sdcard.img" in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX bs=1M conv=fsync

How to boot the board
=====================

The Clearfog GT-8K can be setup to load the bootloader from different sources
including eMMC, SPI flash, and SD-card.

To select boot from SD-card the DIP switches in SW6 (at the bottom of the
board) should be configured as follows:

  SW6: 11010

Insert the micro SDcard in the Cleargfog GT-8K and power it up.

Serial console
==============

The serial console is accessible at the J27 pins header (TTL UART) with the
following pinout (pin #1 is marked with triangle on the PCB):

  pin #1: Ground
  pin #2: Armada 8040 Rx
  pin #3: Armada 8040 Tx

Enable the switch (yellow) Ethernet ports
=========================================

To enable the Clearfog GT-8K internal switch port make sure to load the
'mv88e6xxx' kernel module, and up the switch up-link port (eth2 by default):

  modprobe mv88e6xxx
  ifconfig eth2 up

Then you can configure each switch port separately. These port are named
'lan1' to 'lan4' by default. 'lan1' is closest to the USB port, while 'lan4'
is closest to the blue Ethernet port.
