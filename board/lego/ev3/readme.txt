Lego Mindstorms EV3

Intro
=====

This is the buildroot basic board support for the Lego Mindstorms EV3
programmable brick. No support for sensors and drivers is provided for the
moment.

The Lego Mindstorms EV3 brick comprises a Texas Instruments AM1808 SoC, with
an ARM 926EJ-S main processor running at 300 MHz.
See:
- https://en.wikipedia.org/wiki/Lego_Mindstorms_EV3
- http://www.lego.com/en-us/mindstorms/products/ev3/31313-mindstorms-ev3/
- http://www.ti.com/product/am1808

The buildroot configuration uses the Linux kernel of the ev3dev project.
See:
- http://botbench.com/blog/2013/07/31/lego-mindstorms-ev3-source-code-available/
- https://github.com/mindboards/ev3sources

Note that the EV3 configuration uses gcc 4.7, as the boot is broken with gcc
4.8.

How it works
============

Boot process :
--------------

The u-boot on-board the EV3 brick has provision to boot a Linux kernel from the
external µSD card. It will try to load a uImage from the first µSD card
partition, which must be formatted with a FAT filesystem.

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
    ├── rootfs.ext2
    ├── rootfs.ext3 -> rootfs.ext2
    └── uImage


Prepare your SDcard
===================

The following µSD card layout is recommended:

- First partition formated with a FAT filesystem, containing the uImage.
- Second partition formatted as ext2 or ext3, containing the root filesystem.

Create the SDcard partition table
----------------------------------

Determine the device associated to the SD card :

  $ cat /proc/partitions

Let's assume it is /dev/mmcblk0 :

  $ sudo fdisk /dev/mmcblk0

Delete all previous partitions by creating a new disklabel with 'o', then
create the new partition table, using these options, pressing enter after each
one:

  * n p 1 2048 +10M t c
  * n p 2 22528 +256M

Using the 'p' option, the SD card's partition must look like this :

Device          Boot  Start     End  Blocks  Id System
/dev/mmcblk0p1         2048   22527   10240   c  W95 FAT32 (LBA)
/dev/mmcblk0p2        22528  546815  262144  83  Linux

Then write the partition table using 'w' and exit.

Make partition one a DOS partition :

  $ sudo mkfs.vfat /dev/mmcblk0p1

Install the binaries to the SDcard
----------------------------------

Remember your binaries are located in output/images/, go inside that directory :

  $ cd output/images

Copy the Linux kernel:

  $ sudo mkdir /mnt/sdcard
  $ sudo mount /dev/mmcblk0p1 /mnt/sdcard
  $ sudo cp uImage /mnt/sdcard
  $ sudo umount /mnt/sdcard

Copy the rootfs :

  $ sudo dd if=rootfs.ext3 of=/dev/mmcblk0p2 bs=1M
  $ sync

It's Done!

Finish
======

Eject your µSD card, insert it in your Lego EV3, and power it up.

To have a serial console, you will need a proper USB to Lego serial port
adapter plugged into the EV3 sensors port 1.
See:
- http://botbench.com/blog/2013/08/15/ev3-creating-console-cable/
- http://botbench.com/blog/2013/08/05/mindsensors-ev3-usb-console-adapter/

The serial port config to use is 115200/8-N-1.
