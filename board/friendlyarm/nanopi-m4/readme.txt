Intro
=====

NanoPi M4 is a RK3399 SoC based ARM board.

Wiki: https://wiki.amarulasolutions.com/bsp/rockchip/rk3399/nanopi_m4.html

Build
=====

Run NanoPi M4 configuration

  $ make nanopi_m4_defconfig

To build, run make command.

  $ make

Files created in output directory
=================================
output/images/
├── bl31.bin
├── Image
├── rk3399-nanopi-m4.dtb
├── rootfs.ext2
├── rootfs.ext4 -> rootfs.ext2
├── rootfs.tar
├── sdcard.img
├── u-boot.bin
├── u-boot.itb
├── u-boot-spl-dtb.bin
└── u-boot-spl-dtb.img

Creating bootable SD card:
=========================

Simply invoke (as root)

  # dd if=output/images/sdcard.img of=/dev/sdX && sync

Where X is your SD card device

Serial console
--------------
Baudrate for this board is 1500000
