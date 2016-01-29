OrangePi PC

Intro
=====

This default configuration will allow you to start experimenting with the
buildroot environment for the OrangePi PC. With the current configuration
it will bring-up the board, and allow access through the serial console.

How to build it
===============

Configure Buildroot:

    $ make orangepipc_defconfig

Compile everything and build the SD card image:

    $ make

How to write the SD card
========================

Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX
