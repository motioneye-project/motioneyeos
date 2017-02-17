Nexbox A95X

Intro
=====

Nexbox A95X is a low cost Android STB based around an Amlogic s905(x) SoC
(quad A53), 8/16GB eMMC and 1/2GB RAM.  To use this defconfig, wires to the
internal UART solder pads must be added.  See the linux-meson page for
details:

http://linux-meson.com/doku.php?id=nexbox_a95x_s905

Both the s905 (gxbb) and s905x (gxl) variant is supported.

This default configuration will allow you to start experimenting with the
buildroot environment for the A95X.  With the current configuration it will
bring-up the board from microSD, and allow access through the serial
console.

How to build it
===============

Configure Buildroot:

    $ make nexbox_a95x_defconfig

Compile everything and build the SD card image:

    $ make

How to write the SD card
========================

Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory.

Copy the bootable "sdcard.img" onto a microSD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX

How to boot
===========

Insert microSD card and connect serial cable. Power board and stop
U-Boot by pressing any key. Boot the system by typing:

fatload mmc 0:1 0x1070000 boot.scr
autoscr 0x1070000
