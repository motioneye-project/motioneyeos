
Intel Galileo Gen 1/2

Intro
============

These instructions apply to both the Intel Galileo Gen 1/2 development boards
based on the Intel Quark X1000.

How to build
============

Apply the defconfig for the Intel Galileo Gen 1/2

 $ make galileo_defconfig

Add any additional packages required and build.

 $ make

The build process will create a SD card image and place it in output/images.

 $ ls -lh output/images/sdcard.img
 -rw-r--r--. 1 foo foo 11M Nov 17 16:19 output/images/sdcard.img

Write the image to an mSD card, insert into the Galileo and power on.

 $ dd if=output/images/sdcard.img of=/dev/mmcblk0; sync

Accessing the console
=====================

During power-on the console will become available on the Galileo's ttyS1. This 
may be accessed as follows.

 * Galileo Gen 1

	http://clayskits.com/products/galileo-gen-1-serial-cable

	A USB to RS-232 to 3.5mm Jack cable is required. Connect to the 3.5mm
	Jack next to the Ethernet Header.

 * Galileo Gen 2

	http://www.ftdichip.com/Products/Cables/USBTTLSerial.htm

	A FTDI TTL-232R-3V3 cable may be used to connect to the FTDI header 
	next to the Ethernet connector on the Galileo Gen 2. 

The console should now be visible at 115200 baud.

 $ picocom -b 115200 /dev/ttyUSB0
