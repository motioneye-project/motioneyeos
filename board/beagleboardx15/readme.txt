BeagleBoard X15

Intro
=====
This config currently supports the beagleboard x15,
and generates a barebone image.

The image must be flashed to a SD card to be used.

How to build it
===============

  $ make beagleboardx15_defconfig

Then you can edit the build options using

  $ make menuconfig

Compile all and build a sdcard image:

  $ make

Result of the build
-------------------

After building, you should get a tree like this:

  output/images/
  ├── am57xx-beagle-x15.dtb
  ├── am57xx-beagle-x15-revb1.dtb
  ├── boot.vfat
  ├── MLO
  ├── rootfs.ext2
  ├── rootfs.ext4
  ├── rootfs.tar
  ├── sdcard.img
  ├── u-boot.img
  ├── u-boot-spl.bin
  └── zImage

How to write the microSD card
=============================

Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX
