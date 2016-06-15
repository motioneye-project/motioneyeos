Toradex Apalis i.MX6 Computer on Module

Intro
=====

The Apalis iMX6 is a small form-factor Computer on Module that comes
in both quad core and dual core versions based on Freescale i.MX6Q and
Freescale i.MX6D SoCs respectively. The Cortex A9 quad core and dual
core CPU peaks at 1 GHz for commercial temperature variant, while the
industrial temperature variant has a peak frequency of 800 MHz.

https://www.toradex.com/computer-on-modules/apalis-arm-family/freescale-imx-6

It supports two carrier boards:

Apalis Evaluation Board
https://www.toradex.com/products/carrier-boards/apalis-evaluation-board

Ixora Carrier Board
https://www.toradex.com/products/carrier-boards/ixora-carrier-board

How to build it
===============

Configure Buildroot:

    $ make toradex_apalis_imx6_defconfig

Compile everything and build the rootfs image:

    $ make

How to boot the image
=====================

The board only boots from its internal flash memory eMMC, so the
bootloader image should be copied to it, following the procedures
described in Toradex website.

http://developer.toradex.com/knowledge-base/flashing-linux-on-imx6-modules

Buildroot prepares a "sdcard.img" in output/images/ with the kernel
image, device tree and a root filesystem, ready to be dumped on an SD
card.

    $ dd if=output/images/sdcard.img of=/dev/sdX bs=1M

To boot from the SD card, you should change the U-Boot
environment. Since U-Boot is running from internal eMMC, you will need
to access its command line prompt and manually set the necessary
variables to boot from the external SD card. For convenience, you can
use uEnv.txt provided in output/images/ as a reference to create the
necessary U-Boot variables to boot from the SD card.
