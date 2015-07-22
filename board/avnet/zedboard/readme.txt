This is the buildroot board support for the Avnet Zedboard. The Zedboard is
a development board based on the Xilinx Zynq-7000 based All-Programmable
System-On-Chip.

Zedboard information including schematics, reference designs, and manuals are
available from http://www.zedboard.org .

Steps to create a working system for Zedboard:

1) make zedboard_defconfig
2) make
3) copy files BOOT.BIN, u-boot-dtb.img, rootfs.cpio.uboot,
	uImage, zynq-zed.dtb into your SD card
4) boot your Zedboard

The expected output:

 U-Boot SPL 2015.07 (Jul 22 2015 - 12:01:55)
 mmc boot
 reading system.dtb
 spl_load_image_fat_os: error reading image system.dtb, err - -1
 reading u-boot-dtb.img
 reading u-boot-dtb.img

 U-Boot 2015.07 (Jul 22 2015 - 12:01:55 +0200)

 Model: Zynq ZED Board
 I2C:   ready
 DRAM:  ECC disabled 512 MiB
 MMC:   zynq_sdhci: 0
 Using default environment
 ...

When using an older U-Boot then 2015.07, a working ps7_init.c
file is required to be installed into the U-Boot directory
structure. From 2015.07, the major Zynq-based boards are
supported without any manual intervention.

Resulting system
----------------
A FAT32 partition should be created at the beginning of the SD Card
and the following files should be installed:
	/BOOT.BIN
	/zynq-zed.dtb
	/uImage
	/rootfs-cpio.uboot
	/u-boot-dtb.img


All needed files can be taken from output/images/

BOOT.BIN, uImage and u-boot-dtb.img are direct copies of the same files
available on output/images/

There is a patch attached that redefines the U-Boot's environment
to work with Buildroot out-of-the-box.

You can alter the booting procedure by creating a file uEnv.txt
in the root of the SD card. It is a plain text file in format
<key>=<value> one per line:

kernel_image=myimage
modeboot=myboot
myboot=...
