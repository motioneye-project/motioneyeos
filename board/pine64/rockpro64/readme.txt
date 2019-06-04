Intro
=====

Pine64 RockPro64 is a RK3399 SoC based ARM64 board.

Wiki: https://wiki.pine64.org/index.php/ROCKPro64_Main_Page

Build
=====

Run Pine64 RockPro64 configuration

  $ make pine64_rockpro64_defconfig

To build, run make comamnd.

  $ make

Files created in output directory
=================================

output/images

├── bl31.bin
├── bl31.elf
├── Image
├── rk3399-rockpro64.dtb
├── rootfs.ext2
├── rootfs.ext4 -> rootfs.ext2
├── rootfs.tar
├── sdcard.img
├── u-boot.bin
├── u-boot.itb
├── u-boot-spl-dtb.bin
├── u-boot-tpl-dtb.bin
├── u-boot-tpl-dtb.img
└── u-boot-tpl-spl-dtb.img

Creating bootable SD card:
=========================

Simply invoke (as root)

  # dd if=output/images/sdcard.img of=/dev/sdX && sync

Where X is your SD card device

Serial console
--------------

Baudrate for this board is 1500000
