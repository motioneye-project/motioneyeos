Intro
=====

This default configuration will allow you to start experimenting with the
buildroot environment for the Nanopi NEO2. With the current configuration
it will bring-up the board, and allow access through the serial console.

Nanopi NEO2 link:
http://nanopi.io/nanopi-neo2.html

Wiki link:
https://openedev.amarulasolutions.com/display/ODWIKI/FriendlyARM+NanoPi+NEO2

This configuration uses U-Boot mainline and kernel mainline.

How to build
============

    $ make friendlyarm_nanopi_neo2_defconfig
    $ make

Note: you will need access to the internet to download the required
sources.

How to write the SD card
========================

Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX
  $ sudo sync

Insert the micro SDcard in your Nanopi NEO2 and power it up. The console
is on the serial line, 115200 8N1.
