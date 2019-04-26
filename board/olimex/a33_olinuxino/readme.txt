A33-OLinuXino

Intro
=====

This board is based on Allwinner A33 SoC.

Home Page: https://www.olimex.com/Products/OLinuXino/A33/A33-OLinuXino/open-source-hardware
Wiki: 	   https://wiki.amarulasolutions.com/bsp/sunxi/a33/Olimex-A33-Olinuxino.html

How to build it
===============

Configure Buildroot:

    $ make olimex_a33_olinuxino_defconfig

Build everything by running:

    $ make

Result of the build
-------------------

After building, you should get a tree like this:

output/images/
├── boot.scr
├── rootfs.ext2
├── rootfs.ext4 -> rootfs.ext2
├── rootfs.tar
├── sdcard.img
├── sun8i-a33-olinuxino.dtb
├── u-boot.bin
├── u-boot-sunxi-with-spl.bin
└── zImage


How to write the SD card
========================

The sdcard.img file is a complete bootable image ready to be written
on the boot medium. To install it, simply copy the image to a uSD
card:

    # dd if=output/images/sdcard.img of=/dev/sdX

Where 'sdX' is the device node of the uSD.

Eject the SD card, insert it in the A33-OLinuXino board, and power it up.
