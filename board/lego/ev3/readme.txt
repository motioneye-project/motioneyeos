Lego Mindstorms EV3

Intro
=====

This is the buildroot basic board support for the Lego Mindstorms EV3
programmable brick.

The Lego Mindstorms EV3 brick comprises a Texas Instruments AM1808 SoC, with
an ARM 926EJ-S main processor running at 300 MHz.
See:
- https://en.wikipedia.org/wiki/Lego_Mindstorms_EV3
- http://www.lego.com/en-us/mindstorms/products/ev3/31313-mindstorms-ev3/
- http://www.ti.com/product/am1808

The buildroot configuration uses the Linux kernel of the ev3dev project.
See:
- https://github.com/ev3dev/ev3-kernel/
- https://github.com/ev3dev/lego-linux-drivers/
- http://www.ev3dev.org/

How it works
============

Boot process :
--------------

The EV3 boots from an EEPROM. This loads whatever is on the built-in 16MB flash
(usually U-Boot) and runs it. The U-Boot from the official LEGO firmware and
mainline U-Boot will attempt to boot a Linux kernel from the external µSD card.
It will try to load a uImage (and optional boot.scr) from the first µSD card
partition, which must be formatted with a FAT filesystem. If no µSD is found or
it does not contain a uImage file, then the EV3 will boot the uImage from the
built-in 16MB flash.

How to build it
===============

Configure Buildroot
-------------------

The lego_ev3_defconfig configuration provides basic support to boot on the Lego
Mindstorms EV3 programmable brick:

  $ make lego_ev3_defconfig

Build everything
----------------

Note: you will need to have access to the network, since Buildroot will
download the packages' sources.

  $ make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── boot.vfat
    ├── flash.bin
    ├── rootfs.ext2
    ├── rootfs.ext3 -> rootfs.ext2
    ├── rootfs.squashfs
    ├── sdcard.img
    ├── u-boot.bin
    └── uImage

Installation
============

You can use either flash.bin or the sdcard.img. To load flash.bin, use the
official Lego Mindstorms EV3 programming software firmware update tool to load
the image. To use sdcard.img, use a disk writing tool such as Etcher or dd to
write the image to the µSD card.

Finish
======

To have a serial console, you will need a proper USB to Lego serial port
adapter plugged into the EV3 sensors port 1.
See:
- http://botbench.com/blog/2013/08/15/ev3-creating-console-cable/
- http://botbench.com/blog/2013/08/05/mindsensors-ev3-usb-console-adapter/

The serial port config to use is 115200/8-N-1.
