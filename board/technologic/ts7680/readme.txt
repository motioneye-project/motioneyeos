Technologic Systems TS-7680 SBC
===============================

This document explains how to set up a basic Buildroot system for
the Technologic Systems TS-7680 Single Board Computer.

The TS-7680 SBC is based on the Freescale i.MX286 ARM ARM926EJ-S
running at 454MHz. The TS-7680 features are 10/100 Ethernet ports,
Wi-Fi, microSD card, eMMC, NOR Flash, USB host port, CAN ports,
relays and ADC/DAC. More details on the board here:
https://wiki.embeddedarm.com/wiki/TS-7680

The TS-7680 uses a 3.14.28 Linux kernel provided by
Technologic Systems.

To build the default configuration you only have to run:

  $ make ts7680_defconfig
  $ make

The output looks like:
output/images
├── imx28-ts7680.dtb
├── rootfs.ext2
├── rootfs.ext4 -> rootfs.ext2
├── rootfs.tar
├── sdcard.img
└── uImage

The provided genimage configuration generates an image file containing
two partitions. The first one is unused, but mandatory as the
TS-7680 built-in bootloader loads the Linux uImage from the /boot
directory in the second partition. The second partition contains the
rootfs with the Linux uImage into the /boot directory.

  $ fdisk output/images/sdcard.img
  output/images/sdcard.img1          1      1       1  512B  0 Empty
  output/images/sdcard.img2          2 524289  524288  256M 83 Linux

This image can be directly written to an SD card.

    $ sudo dd if=output/images/sdcard.img of=/dev/mmcblk0

To boot with Buildroot, insert this SD card on the board, make sure
the SD jumper is present and the U-Boot jumper is not.

The bootloader comes pre-flashed on the board on an SPI flash. Since
updating the bootloader is risky and not trivial, it is not included
in the Buildroot defconfig. Refer to
https://wiki.embeddedarm.com/wiki/TS-7680#U-Boot for details on
which U-Boot config to use and how to flash it.
