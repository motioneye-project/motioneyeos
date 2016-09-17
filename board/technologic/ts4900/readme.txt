Technologic Systems TS-4900
===========================

This document explains how to set up a basic Buildroot system for the
Technologic Systems TS-4900 System on Module.

The TS-4900 is a TS-SOCKET macrocontroller board based on the
Freescale i.MX6 Single or Quad Core ARM Cortex-A9 CPU clocked at
1GHz. The TS-4900 features Gigabit Ethernet, SATA II Port, PCI Express
Bus, high speed USB host and device (OTG), and microSD card.
More details on the board here:
   http://wiki.embeddedarm.com/wiki/TS-4900

The TS-4900 is not currently supported by mainline Linux, so a
Technologic Systems Linux is used based on Linux 4.1.
The default U-boot configuration flashed scans the SD card to find the
0x83 partition type, corresponding to the rootfs. Then it will load
both uImage and dts from the /boot directory.
To build the default configuration you only have to:

   $ make ts4900_defconfig
   $ make

The output looks like:
output/images/
├── imx6q-ts4900.dtb
├── rootfs.ext2
├── rootfs.tar
├── sdcard.img
└── uImage

Since both the uImage and the dts are contained in the /boot
directory, the provided post-image script generates an image file
containing only one partition for the rootfs:

   $ fdisk output/images/sdcard.img
                      Device Boot Start    End Blocks Id  System
output/images/sdcard.img1               1      524288      262144   83  Linux

This image can be directly written to an SD card.

   $ sudo dd if=output/images/sdcard.img of=/dev/mmcblk0

In order to test the image on TS-4900 board, a TS baseboard, such as
the TS-9xxx series, is needed to provide power, console header, RJ45
connector etc.

The bootloader comes pre-flashed on the board on an SPI flash. Since
updating the bootloader is risky and not trivial, it is not included
in the Buildroot defconfig. Refer to
http://wiki.embeddedarm.com/wiki/TS-4900#U-Boot for details on which
U-Boot config to use and how to flash it.
