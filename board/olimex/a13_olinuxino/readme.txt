A13-OLinuXino

Intro
=====

This default configuration will allow you to start experimenting with
the buildroot environment for the A13-OLinuXino. With the current
configuration it will bring-up the board, and allow access through the
serial console.

For more details about the A13-OLinuXino:

https://www.olimex.com/Products/OLinuXino/A13/A13-OLinuXino/open-source-hardware

How to build it
===============

Configure Buildroot:

    $ make olimex_a13_olinuxino_defconfig

Compile everything and build the rootfs image:

    $ make

Note: you will need access to the internet to download the required
sources.

How to write the SD card
========================

The sdcard.img file is a complete bootable image ready to be written
on the boot medium. To install it, simply copy the image to a micro SD
card:

    # dd if=output/images/sdcard.img of=/dev/sdX

Notes:
  - replace 'sdX' with the actual device with your micro SDcard,
  - you may need to be root to do that (use 'sudo').

Eject the SD card, insert it in the A13-OLinuXino board, and power it
up.
