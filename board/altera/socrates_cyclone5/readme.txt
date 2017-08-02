EBV SoCrates Evaluation Board

Intro
=====

More information about this board can be found here:
https://rocketboards.org/foswiki/Documentation/EBVSoCratesEvaluationBoard

Build
=====

First, load socrates config for buildroot

    make socrates_cyclone5_defconfig

Build everything

    make

Following files will be generated in output/images

.
├── boot.vfat
├── rootfs.ext2
├── rootfs.ext4 -> rootfs.ext2
├── rootfs.tar
├── sdcard.img
├── socfpga_cyclone5_socrates.dtb
├── u-boot-spl.bin
├── u-boot-spl.bin.crc
├── u-boot.bin
├── u-boot.img
├── uboot-env.bin
├── uboot.img
└── zImage


Creating bootable SD card
=========================

Simply invoke

dd if=output/images/sdcard.img of=/dev/sdX

Where X is your SD card device (not partition)

Booting
=======

Pins 6:8 on P18 selector is used to determine boot device. To boot socrates from
sdcard set these pins to value 0x5 (101b). Remaining pins are used to determine
how to configure FPGA and are not associated with booting into Linux kernel.
