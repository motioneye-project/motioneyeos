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
  ├── rootfs.ext2
  ├── u-boot.img
  └── zImage

Setting up your SD card
-----------------------

*Important*: pay attention which partition you are modifying so you don't
accidentally erase the wrong file system, e.g your host computer or your
external storage!

In the default setup you need to create two partitions on your SD card:
a boot partition and a rootfs partition.

The ROM code from OMAP processors need the SD card to be formatted with
a special geometry in the partition table. To do that, you can use the
shell script below (this script was extracted from
http://elinux.org/Panda_How_to_MLO_%26_u-boot).

#!/bin/sh
DRIVE=$1
if [ -b "$DRIVE" ] ; then
	dd if=/dev/zero of=$DRIVE bs=1024 count=1024
	SIZE=`fdisk -l $DRIVE | grep Disk | awk '{print $5}'`
	echo DISK SIZE - $SIZE bytes
	CYLINDERS=`echo $SIZE/255/63/512 | bc`
	echo CYLINDERS - $CYLINDERS
	{
	echo ,9,0x0C,*
	echo ,,,-
	} | sfdisk -D -H 255 -S 63 -C $CYLINDERS $DRIVE
	mkfs.vfat -F 32 -n "boot" ${DRIVE}1
	mke2fs -j -L "rootfs" ${DRIVE}2
fi

The next step is to mount the sdcard's first partition and copy MLO
and u-boot.img to it.

  $ sudo mkdir -p /mnt/sdcard
  $ sudo mount /dev/sdX1 /mnt/sdcard
  $ sudo cp MLO u-boot.img /mnt/sdcard
  $ sudo umount /mnt/sdcard

The last step is to copy the rootfs image to the sdcard's second
partition using 'dd':

  $ sudo dd if=rootfs.ext2 of=/dev/sdX2 bs=1M conv=fsync
