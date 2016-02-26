Pandaboard
==========

This file documents the Buildroot support for the Pandaboard, a
low-power, low-cost single-board computer development platform based
on the Texas Instruments OMAP4 system on a chip (SoC).

Configuring and building Buildroot
----------------------------------

Start from the defconfig:

  $ make pandaboard_defconfig

You can edit build options the usual way:

  $ make menuconfig

When you are happy with the setup, run:

  $ make

The result of the build with the default settings should be these files:

  output/images
  ├── MLO
  ├── omap4-panda-a4.dtb
  ├── omap4-panda.dtb
  ├── omap4-panda-es.dtb
  ├── rootfs.ext4
  ├── sdcard.img
  ├── u-boot.img
  └── zImage

How to write the SD card
------------------------

Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX

Where /dev/sdX is the device node of your SD card (may be /dev/mmcblkX
instead depending on setup).
