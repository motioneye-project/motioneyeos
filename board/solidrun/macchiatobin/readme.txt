Intro
=====

This default configuration will allow you to start experimenting with
the buildroot environment for the MacchiatoBin board based on the
Marvell Armada 8040 SoC. Documentation for the board hardware and
software is available on the wiki at: http://wiki.macchiatobin.net

This default configuration will bring up the board and allow access
through the serial console.

How to build
============

There are two build options: mainline support and vendor support.

For the mainline BSP, we use:
 - Linux v4.19.2
 - U-Boot v2018.11

For the vendor BSP, we use the sources available from Marvell Github
page at https://github.com/MarvellEmbeddedProcessors, which uses:
 - Linux v4.4.120
 - U-Boot v2018.03

At the moment mainline support for the board is a work in
progress. Mainline kernel 4.19 enables eth2 in 1Gb (RJ45 connector J5),
copper 10Gb interfaces, and automatic configuration of select SFP
modules on the SFP cages. The vendor BSP enables more hardware features
out of the box, but lacks support for SFP detection and automatic
configuration.

To use the mainline BSP run the following commands:

    $ make solidrun_macchiatobin_mainline_defconfig
    $ make

To use the vendor BSP run the following commands:

    $ make solidrun_macchiatobin_marvell_defconfig
    $ make

How to write the SD card
========================

Once the build process is finished you will have an image
called "sdcard.img" in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX bs=1M conv=fsync
  $ sudo sync

How to boot the board
=====================

The MacchiatoBin board can be setup to load the bootloader from
different sources including eMMC, SPI flash, and SD-card.

On Rev 1.2 board to select boot from SD-card the DIP switches
SW1 and SW2 should be configured as follows:

SW2: 01110
SW1: 1xxxx

The upcoming Rev 1.3 board will have a single pins header J1 instead
of the SW1/2 DIP switches. To boot from SD-card the setting of J1
jumpers should match the DIP switches of Rev v1.2 board
from left to right:

J1: 011101xxxx

Insert the micro SDcard in the MacchiatoBin board and power it up.
The serial console is accessible at the micro-USB Type-B connector
marked CON9. The serial line settings are 115200 8N1.

Note: the following text only applies to the vendor BSP from
solidrun_macchiatobin_marvell_defconfig.

By default Marvell provided U-Boot will load its environment from the
SPI flash. On the first boot SPI flash may be empty or it may contain a
legacy environment that prevents proper boot. Then the following
commands can be used to boot the board:

=> ext4load mmc 1:1 0x01700000 /boot/uEnv-example.txt
=> env import -t 0x01700000 $filesize
=> boot

The example environment from uEnv-example.txt can be written to
SPI flash using the following commands:

=> env default -f -a
=> ext4load mmc 1:1 0x01700000 /boot/uEnv-example.txt
=> env import -t 0x01700000 $filesize
=> saveenv
