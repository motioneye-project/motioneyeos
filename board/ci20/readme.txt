*********************
* MIPS Creator CI20 *
*********************

The 'ci20_defconfig' will create a root filesystem and a kernel image
under the 'output/images/' directory. This document will try to explain how
to use them in order to run Buildroot in the MIPS Creator CI20 board.

Assuming you are at the U-Boot prompt of the MIPS Creator CI20, you have to
load the generated kernel image by using the 'tftpboot' command. In
order to do that, you will need to get the network working. Here you
have the instructions to set the ip address, netmask and gateway:

  setenv ipaddr x.x.x.x
  setenv netmask x.x.x.x
  setenv gatewayip x.x.x.x

Now you have to set the ip for the TFTP server you are going to load the
kernel image from, and also the name of the kernel image file (we use
'uImage' as a filename in this example):

  setenv serverip x.x.x.x
  setenv bootfile uImage

And finally load the kernel image:

  tftpboot

Now you have to extract the generated root filesystem into a USB drive
or SD-Card. Here you have the instructions to boot from the two of them.
You have to choose the one your prefer:

From USB
  setenv bootargs console=ttyS4,115200 console=tty0 mem=256M@0x0
mem=768M@0x30000000 root=/dev/sda1

From SD-Card
  setenv bootargs console=ttyS4,115200 console=tty0 mem=256M@0x0
mem=768M@0x30000000 root=/dev/mmcblk0p1

And finally run this command to boot the board:
  bootm
