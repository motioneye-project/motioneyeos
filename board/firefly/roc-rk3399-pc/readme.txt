Libre Computer Board ROC-RK3399-PC
===================================

Build:

  $ make roc_pc_rk3399_defconfig
  $ make

Files created in output directory
=================================

output/images

├── bl31.elf
├── idbloader.img
├── Image
├── rk3399-roc-pc.dtb
├── rootfs.ext2
├── rootfs.ext4 -> rootfs.ext2
├── rootfs.tar
├── sdcard.img
├── u-boot.bin
└── u-boot.itb

Creating bootable SD card:
==========================

Simply invoke (as root)

sudo dd if=output/images/sdcard.img of=/dev/sdX && sync

Where X is your SD card device

Serial console
--------------

Baudrate for this board is 1500000

Wiki link:
https://wiki.amarulasolutions.com/bsp/rockchip/rk3399/roc-rk3399-pc.html
