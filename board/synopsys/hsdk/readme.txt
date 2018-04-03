Synopsys, Inc.
ARC HS Development Kit (HSDK)

https://embarc.org/platforms.html

How to build it
===============

Select the default configuration for the target:
$ make snps_archs38_hsdk_defconfig

Optional: modify the configuration:
$ make menuconfig

Build:
$ make

Result of the build
===================
output/images/
├── boot.vfat
├── rootfs.ext2
├── sdcard.img
├── u-boot
├── u-boot.bin
├── uboot-env.bin
└── uImage

To copy the image file to the sdcard use dd:
$ dd if=output/images/sdcard.img of=/dev/XXX

2018, Evgeniy Didin <Evgeniy.Didin@synopsys.com>

