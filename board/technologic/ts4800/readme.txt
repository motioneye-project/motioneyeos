Technologic Systems TS-4800
===========================

This document explains how to set up a basic Buildroot system for the
Technologic Systems TS-4800 System on Module.

The TS-4800 is a TS-SOCKET macrocontroller board based on the Freescale
i.MX515 ARM Cortex-A8 CPU running at 800MHz. The TS-4800 features 10/100
Ethernet, high speed USB host and device (OTG), microSD card, and 256MB
XNAND drive.  More details on the board here:
	http://wiki.embeddedarm.com/wiki/TS-4800

The TS-4800 is supported by mainline Linux as of 4.5 and by U-boot as of
v2016-07. The defconfig includes a custom 1st level bootloader located
in boot/ts4800-mbrboot. This one scans the SD card's partition table to
find partition having the 0xDA type, corresponding to U-boot.

To build the default configuration you only have to:

	$ make ts4800_defconfig
	$ make

The ouput looks like:
	output/images/
	├── boot.vfat
	├── imx51-ts4800.dtb
	├── mbrboot.bin
	├── rootfs.ext2
	├── rootfs.ext4 -> rootfs.ext2
	├── rootfs.tar
	├── sdcard.img
	├── u-boot.bin
	└── zImage

The provided post-image script generates an image file containing 3
partitions for U-boot, Linux kernel + device tree and rootfs
respectively:
	$ fdisk output/images/sdcard.img
	                   Device Boot Start    End Blocks Id  System
	output/images/sdcard.img1          1    512    256 da  Non-FS data
	output/images/sdcard.img2        513  16896   8192  c  W95 FAT32 (LBA)
	output/images/sdcard.img3      16897 541184 262144 83  Linux

This image can be directly written to an SD card.

	$ sudo dd if=output/images/sdcard.img of=/dev/mmcblk0

In order to test the image on TS-4800 board, a TS baseboard, such as
TS-8xxx the serie, is needed to provide power, console header, RJ45
connector etc.
