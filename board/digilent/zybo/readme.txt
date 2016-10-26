Digilent Zybo
=============

This is the Buildroot board support for the Digilent Zybo. The Zybo is
a development board based on the Xilinx Zynq-7000 based All-Programmable
System-On-Chip.

Zybo information including schematics, reference designs, and manuals are
available from http://store.digilentinc.com/zybo-zynq-7000-arm-fpga-soc-trainer-board/ .

If you want a custom FPGA bitstream to be loaded by U-Boot, copy it as
system.bit in board/digilent/zybo/.

Steps to create a working system for Zybo:

1) make zynq_zybo_defconfig
2) make
3) write your SD Card with the sdcard.img file using dd by doing
  $ sudo dd if=output/images/sdcard.img of=/dev/sdX
4) insert the SD Card and power up your Zybo
5) Expect serial console on the second USB serial port exposed by the board

The expected output:

 U-Boot SPL 2016.05 (May 20 2016 - 16:16:24)
 mmc boot
 Trying to boot from MMC1
 reading system.dtb
 spl_load_image_fat_os: error reading image system.dtb, err - -1
 reading u-boot-dtb.img
 reading u-boot-dtb.img


 U-Boot 2016.05 (May 20 2016 - 16:16:24 +0200)

 Model: Zynq ZYBO Development Board
 Board: Xilinx Zynq
 I2C:   ready
 DRAM:  ECC disabled 512 MiB
 MMC:   sdhci@e0100000: 0
 SF: Detected S25FL128S_64K with page size 256 Bytes, erase size 64 KiB, total 16 MiB
 In:    serial@e0001000
 Out:   serial@e0001000
 Err:   serial@e0001000
 Model: Zynq ZYBO Development Board
 Board: Xilinx Zynq
 Net:   ZYNQ GEM: e000b000, phyaddr 0, interface rgmii-id
 I2C EEPROM MAC address read failed

 Warning: ethernet@e000b000 (eth0) using random MAC address - 56:64:dd:a7:6d:94
 eth0: ethernet@e000b000
 ...

Resulting system
----------------
Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory.

The first partition is a FAT32 partition created at the beginning of the SD Card
that contains the following files :
    /BOOT.BIN
    /zynq-zybo.dtb
    /uEnv.txt
    /system.bit
    /uImage
    /u-boot-dtb.img

The second partition is an ext4 partition that contains the root filesystem.

You can alter the booting procedure by modifying the uEnv.txt file
in first partition of the SD card. It is a plain text file in format
<key>=<value> one per line:

kernel_image=myimage
modeboot=myboot
myboot=...
