*********************************
Technexion i.MX8M Mini Pico board
*********************************

This file documents the Buildroot support for the Technexion i.MX8M
Mini Pico board. The Pico i.MX8M Mini system-on-module [1] is present
in development kits like the Pico Pi i.MX8M Mini [2].

Build
=====

First, configure Buildroot for the i.MX8M Mini Pico board:

  make imx8mmpico_defconfig

Build all components:

  make

You will find in output/images/ the following files:
  - bl31.bin
  - boot.vfat
  - Image
  - imx8-boot-sd.bin
  - imx8mm-pico-pi.dtb
  - imx8mm-pico-pi-ili9881c.dtb
  - imx8mm-pico-pi-sn65dsi84-hj070na.dtb
  - lpddr4_pmu_train_fw.bin
  - rootfs.ext2
  - rootfs.ext4
  - sdcard.img
  - u-boot.imx

Flashing sdcard.img on the eMMC
===============================

i.MX8M Mini Pico board does not have a SD card slot. The storage is an
eMMC. An easy way to flash the eMMC is to use the u-boot ums
command. The boards are sold pre-flashed with such a u-boot. It is
assumed here that the board has already a working u-boot on eMMC and
jumpers are set to boot on eMMC. See [3].

Jumper configuration for eMMC boot:
J1: jumper on pins 4 and 6.
J2: jumper on pins 2 and 4.

In case the board was flashed with a wrong u-boot, or the eMMC is
erased, u-boot can be loaded by USB Serial Download boot mode, using
imx-usb-loader. See [3] and [4].

For flashing:
- Plug the micro USB cable from the Debug USB Port, to your computer
- Plug the USB Type C to your computer, this will power up the board

In the U-Boot prompt launch:

=> ums 0 mmc 1

This will mount the eMMC content in the host PC as a mass storage device.

To determine the device associated to the eMMC card have a look in the
/proc/partitions file:

  cat /proc/partitions

If your system automatically mount some device partitions, make sure
to unmount them.

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on the eMMC. Launch the following
command as root:

  dd if=output/images/sdcard.img of=/dev/<your-sd-device>

*** WARNING! This will destroy all the eMMC content. Use with care! ***

This operation can take several minutes, depending on the image
size. When tested, a 2MB/s transfer rate was observed.

For details about the medium image layout, see the definition in
board/freescale/common/imx/genimage.cfg.template.

Boot the i.MX8M Mini Pico board
===============================

To boot your newly created system:
- put a micro USB cable into the Debug USB Port and connect using a terminal
  emulator at 115200 bps, 8n1;
- power on the board, with USB Type C connector.

Enjoy!

[1]. https://www.technexion.com/products/system-on-modules/pico/pico-compute-modules/detail/PICO-IMX8M-MINI
[2]. https://www.technexion.com/products/pico-evaluation-kits/detail/PICOPIIMX8MM1GDEV
[3]. https://www.technexion.com/support/knowledgebase/boot-configuration-settings-for-pico-baseboards/
[4]. https://www.technexion.com/support/knowledgebase/loading-bootable-software-images-onto-the-emmc-of-picosom-on-pico-pi/
