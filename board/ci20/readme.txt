*********************
* MIPS Creator CI20 *
*********************

Introduction
============

The 'ci20_defconfig' will create a root filesystem and a kernel image
under the 'output/images/' directory. This document will try to explain how
to use them in order to run Buildroot in the MIPS Creator CI20 board.

How to build it
===============

Configure Buildroot
-------------------

  $ make ci20_defconfig

Build the rootfs
----------------

Note: you will need to have access to the network, since Buildroot will
download the packages' sources.

You may now build your rootfs with:

  $ make

(This may take a while, consider getting yourself a coffee ;-) )

How to write the SD card
========================

Once the build process is finished you will have an image called
"sdcard.img" in the output/images/ directory.

Make sure the SD card is not mounted then copy the bootable "sdcard.img" onto
it with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX

Insert the SDcard into your ci20, and power it up. Your new system
should come up now and start a console on the UART HEADER.

see: https://elinux.org/CI20_Hardware#Dedicated_UART_header
