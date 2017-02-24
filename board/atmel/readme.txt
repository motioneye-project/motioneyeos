This document explains how to set up a basic Buildroot system on various
Atmel boards. Additional details can also be found on the Linux4SAM website:
http://www.at91.com/linux4sam/bin/view/Linux4SAM/

This guide covers the following configurations:
 - at91sam9g45m10ek_defconfig
 - at91sam9rlek_defconfig
 - at91sam9x5ek_defconfig (at91sam9g15, at91sam9g25, at91sam9x25,
   at91sam9g35 and at91sam9x35)
 - atmel_sama5d3xek_defconfig (sama5d31, sama5d33, sama5d34, sama5d35,
   sama5d36)
 - atmel_sama5d3_xplained_defconfig
 - atmel_sama5d3_xplained_dev_defconfig
 - atmel_sama5d3_xplained_mmc_defconfig
 - atmel_sama5d3_xplained_mmc_dev_defconfig
 - atmel_sama5d4_xplained_defconfig
 - atmel_sama5d4_xplained_dev_defconfig
 - atmel_sama5d4_xplained_mmc_defconfig
 - atmel_sama5d4_xplained_mmc_dev_defconfig
 - atmel_sama5d2_xplained_mmc_defconfig
 - atmel_sama5d2_xplained_mmc_dev_defconfig

These configurations will use AT91Bootstrap, u-boot and a linux kernel from
the git trees maintained by Atmel.

The configurations labeled as 'dev' provide a development rootfs with tools to
tests the features of the SoC:
- ALSA tools to test audio
- FFMPEG to record video from the ISI/ISC
- I2C, SPI, CAN, etc. tools
- modetest for LCD screens, HDMI
- Wilc1000 firmware for the Atmel Wireless sdio module
- SSH for convenience
- GDB/GDB server for debug

Configuring and building Buildroot
==================================

For most configurations listed above, the Buildroot configuration
assumes the system will be flashed on NAND. In this case, after
building Buildroot, follow the instructions in the "Flashing the NAND
using SAM-BA" section below.

For the Xplained boards, an alternative Buildroot configuration is
provided to boot from an SD card. Those configurations are labeled as
'mmc'. In this case, after building Buildroot, follow the instructions
in the "Preparing the SD card" section.

To configure and build Buildroot, run:

  make <board>_defconfig
  make

Flashing the NAND using SAM-BA
==============================

Flashing the board
------------------

Connect the board:
 o at91sam9g45m10ek: DBGU: J10, USB sam-ba: J14
 o at91sam9rlek: DBGU: J19, USB sam-ba: J21
 o at91sam9x5ek: DBGU: J11, USB sam-ba: J20
 o sama5d3xek: DBGU: J14, USB sam-ba: J20
 o sama5d3 Xplained: DBGU: J23, USB sam-ba: J6
 o sama5d4ek: DBGU: J22 or J24, USB sam-ba: J1
 o sama5d4 Xplained: DBGU: J1, USB sam-ba: J11

Start the board in RomBOOT:
 o at91sam9g45m10ek:
    1. open JP8, JP10 and JP12
    2. start the board
    3. close JP8, JP10 and JP12

 o at91sam9rlek:
   1. J11 on 1-2 (BMS=1), open J12 and J13
   2. start the board
   3. close J12 and J13

 o at91sam9x5ek:
   1. open JP9 and:
      - Cogent: open *NCS jumper
      - Embest: open SW1
      - Ronetix: open J1 and J2
   2. start the board
   3. close JP9 and:
      - Cogent: close *NCS jumper
      - Embest: close SW1 (ON position)
      - Ronetix: close J1 and J2

 o sama5d3xek:
   1. start the board
   2. push BP4 and BP1
   3. release BP1
   4. release BP4

 o sama5d3 Xplained:
   1. open JP5 (NANDCS) and JP6 (SPICS)
   2. start the board
   3. close JP5 ans JP6

 o sama5d4ek:
   1. start the board
   2. push BP3 and BP4
   3. release BP4
   4. release BP3

 o sama5d4 Xplained:
   1. close JP7 (BOOT_DIS)
   2. start the board
   3. open JP7

"RomBOOT" should appear on your console (this should be ttyUSBx or ttyACMx)

Now locate the USB sam-ba interface it should be ttyACMx, usually ttyACM0
dmesg on your machine should give:
usb 1-2.1.4: New USB device found, idVendor=03eb, idProduct=6124
usb 1-2.1.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
cdc_acm 1-2.1.4:1.0: ttyACM0: USB ACM device

Look for idVendor=03eb, idProduct=6124, this is the interface you want to use.

You can then flash the board using the provided flasher.sh script in board/atmel:

board/atmel/flasher.sh <builddir_path> <interface> <board>

For example, for an out of tree build made in
/tmp/atmel_sama5d3_xplained/ for the sama5d3 Xplained, you would use:
board/atmel/flasher.sh /tmp/atmel_sama5d3_xplained/ /dev/ttyACM0 sama5d3_xplained

Reboot, the system should boot up to the buildroot login invite.

Preparing the SD card
=====================

An image named sdcard.img is automatically generated. With this image,
you no longer have to care about the creation of the partition and
copying files to the SD card.

You need at least a 1GB SD card. All the data on the SD card will be
lost. To copy the image on the SD card:

/!\ Caution be sure to do it on the right mmcblk device /!\

dd if=output/images/sdcard.img of=/dev/mmcblk0

Insert your SD card in your Xplained board, and enjoy. The default
U-Boot environment will load properly the kernel and Device Tree blob
from the first partition of the SD card, so everything works
automatically.

By default a 16MB FAT partition is created. It contains at91bootstrap,
u-boot, the kernel image and all dtb variants for your board. The dtb
used is the basic one:

U-Boot> print
[...]
bootcmd=fatload mmc 1:1 0x21000000 at91-sama5d2_xplained.dtb; fatload mmc 1:1 0x22000000 zImage; bootz 0x22000000 - 0x21000000
[...]

If you want to use a variant such as the _pda7 one, you will have to
update your u-boot environment:

U-Boot> setenv bootcmd 'fatload mmc 1:1 0x21000000 at91-sama5d2_xplained_pda7.dtb; fatload mmc 1:1 0x22000000 zImage; bootz 0x22000000 - 0x21000000'
U-Boot> save
Saving Environment to FAT...
writing uboot.env
done

A 512MB ext4 partition is also created to store the rootfs generated.

If you want to customize the size of the partitions and their content,
take a look at the the genimage.cfg file in the board directory.
