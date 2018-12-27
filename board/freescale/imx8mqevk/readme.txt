***************************
Freescale i.MX8MQ EVK board
***************************

This file documents the Buildroot support for the Freescale i.MX8MQ
EVK board.

Build
=====

First, configure Buildroot for the i.MX8MQ EVK board:

  make freescale_imx8mqevk_defconfig

Build all components:

  make

You will find in output/images/ the following files:
  - bl31.bin
  - boot.vfat
  - fsl-imx8mq-evk.dtb
  - Image
  - imx8-boot-sd.bin
  - lpddr4_pmu_train_fw.bin
  - rootfs.ext2
  - rootfs.ext4
  - rootfs.tar
  - sdcard.img
  - signed_hdmi_imx8m.bin
  - u-boot.bin
  - u-boot.imx
  - u-boot-nodtb.bin
  - u-boot-spl-ddr.bin

Create a bootable SD card
=========================

To determine the device associated to the SD card have a look in the
/proc/partitions file:

  cat /proc/partitions

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on a SD card. Launch the following
command as root:

  dd if=output/images/sdcard.img of=/dev/<your-sd-device>

*** WARNING! This will destroy all the card content. Use with care! ***

For details about the medium image layout, see the definition in
board/freescale/common/imx/genimage.cfg.template_imx8.

Boot the i.MX8MQ EVK board
==========================

To boot your newly created system:
- insert the SD card in the SD slot of the board;
- Configure the switches as follows:
SW801:	ON	ON	OFF	OFF
SW802:	ON	OFF
- put a micro USB cable into the Debug USB Port and connect using a terminal
  emulator at 115200 bps, 8n1;
- power on the board.

Enable HDMI output
==================

To enable HDMI output at boot you must provide the video kernel boot
argument.  To set the video boot argument from U-Boot run after
stopping in U-Boot prompt:

setenv mmcargs 'setenv bootargs console=${console} root=${mmcroot} video=HDMI-A-1:1920x1080-32@60'
saveenv
reset

Change screen resolution to suit your connected display.

Enjoy!
