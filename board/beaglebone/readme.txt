CircuitCo BeagleBone
Texas Instuments AM335x Evaluation Module (TMDXEVM3358)

Description
===========

This configuration will build a complete image for the beaglebone and
the TI AM335x-EVM, the board type is identified by the on-board
EEPROM. The configuration is based on the
ti-processor-sdk-02.00.00.00. Device tree blobs for beaglebone
variants and the evm-sk are built too.

For Qt5 support support use the beaglebone_qt5_defconfig.

How to build it
===============

Select the default configuration for the target:
$ make beaglebone_defconfig

Optional: modify the configuration:
$ make menuconfig

Build:
$ make

Result of the build
===================
output/images/
├── am335x-boneblack.dtb
├── am335x-bone.dtb
├── am335x-evm.dtb
├── am335x-evmsk.dtb
├── boot.vfat
├── MLO
├── rootfs.ext2
├── rootfs.tar
├── sdcard.img
├── u-boot.img
├── uEnv.txt
└── zImage

To copy the image file to the sdcard use dd:
$ dd if=output/images/sdcard.img of=/dev/XXX

Tested hardware
===============
am335x-evm (rev. 1.1A)
beagleboneblack (rev. A5A)
beaglebone (rev. A6)

2016, Lothar Felten <lothar.felten@gmail.com>
