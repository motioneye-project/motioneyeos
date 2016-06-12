pcDuino v1 boards (http://www.linksprite.com/linksprite-pcduino)

Intro
=====

This default configuration will allow you to start experimenting
with the buildroot environment for the LinkSprite pcDuino v1 board
including its flavors pcDuino-Lite and pcDuino-Lite-WiFi. With the
current configuration it will bring-up the board and allow access
through the serial console as well as ethernet and wireless
network interfaces.

How to build it
===============

Configure Buildroot:

    $ make linksprite_pcduino_defconfig

Modify configuration if needed, e.g. add more packages to target:

    $ make menuconfig

Compile everything and build the SD card image:

    $ make

How to write the SD card
========================

Once the build process is finished you will have an image
called "sdcard.img" in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX

How to boot new image
=====================

Insert SD card and reset the board. By default pcDuino board
boots from SD card.
