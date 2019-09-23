Intro
=====

This configuration will build a basic image for the BeagleBoard.org
BeagleBone AI. For more details about the board, visit:

https://beagleboard.org/ai

How to build it
===============

Configure Buildroot:

    $ make beagleboneai_defconfig

Compile everything and build the USB flash drive image:

    $ make

How to write the SD card
========================

Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX
