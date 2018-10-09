Intro
=====

This default configuration will allow you to start experimenting with the
buildroot environment for the Bananapi M2 ULtra. With the current
configuration it will bring-up the board, and allow access through the
serial console.

Bananapi M2 Ultra link:
http://www.banana-pi.org/m2u.html

This configuration uses U-Boot mainline and kernel mainline.

How to build
============

    $ make bananapi_m2_ultra_defconfig
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

Insert the micro SDcard in your Bananapi M2 Ultra and power it up. The console
is on the serial line, 115200 8N1.
