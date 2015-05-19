Flashing the NAND using SAM-BA
==============================

This document explains how to flash a basic Buildroot system on various
Atmel boards. Additional details can
also be found on the Linux4SAM website, in particular here:
http://www.at91.com/linux4sam/bin/view/Linux4SAM/GettingStarted

This guide covers the following configurations:
 - at91sam9g45m10ek_defconfig
 - at91sam9rlek_defconfig
 - at91sam9x5ek_defconfig (at91sam9g15, at91sam9g25, at91sam9x25,
   at91sam9g35 and at91sam9x35)
 - atmel_sama5d3xek_defconfig (sama5d31, sama5d33, sama5d34, sama5d35,
   sama5d36)
 - atmel_sama5d3_xplained_defconfig
 - atmel_sama5d4ek_defconfig
 - atmel_sama5d4_xplained_defconfig

These configurations will use AT91Bootstrap, u-boot and a linux kernel from
the git trees maintained by Atmel. They also build u-boot SPL when
available, it can replace AT91Bootstrap.


Configuring and building Buildroot
----------------------------------

  make <board>_defconfig
  make


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

