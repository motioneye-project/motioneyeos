**********
chiliBoard
**********

Build
=====

First, configure Buildroot for your chiliBoard:

  make grinn_chiliboard_defconfig

Build image:

  make

After building you should get a tree like this:

  output/images/
  ├── am335x-chiliboard.dtb
  ├── boot.vfat
  ├── MLO
  ├── rootfs.ext2
  ├── rootfs.ext4
  ├── rootfs.tar
  ├── sdcard.img
  ├── u-boot.img
  └── zImage

Create a bootable microSD card
==============================

Buildroot prepares a bootable microSD card image "sdcard.img" in output/images/
directory, To flash SD card just run the following command:

  sudo dd if=output/images/sdcard.img of=/dev/<sd_card> bs=1M

where <sd_card> can be sdX or mmcblkX

*** WARNING! This will destroy all contents of device you specify! ***

Boot chiliBoard
===============

- insert the microSD card in the microSD slot of the board;
- plug micro USB cable to provide power and console interface
- use terminal emulator with 115200 bps, 8n1
