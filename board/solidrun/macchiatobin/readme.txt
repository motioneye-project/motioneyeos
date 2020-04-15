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

Default configuration provides the following BSP versions:
 - Linux v5.6.3 (mainline)
 - U-Boot v2020.01 (mainline)
 - ATF v1.5-18.12.2 (Marvell)

To build images run the following commands:

    $ make solidrun_macchiatobin_defconfig
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

U-Boot environment
==================

By default current configuration provides U-Boot that keeps environment
in SD/eMMC. However, if needed, u-boot-fragment.config can be tweaked
so that U-Boot will keep environment in SPI flash. On the first boot
SPI flash may be empty or it may contain a stale environment that
prevents proper boot. Then the following commands can be used
to boot the board:

=> ext4load mmc 1:1 0x01700000 /boot/uEnv-example.txt
=> env import -t 0x01700000 $filesize
=> boot

The example environment from uEnv-example.txt can be written to
SPI flash using the following commands:

=> env default -f -a
=> ext4load mmc 1:1 0x01700000 /boot/uEnv-example.txt
=> env import -t 0x01700000 $filesize
=> saveenv
