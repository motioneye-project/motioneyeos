STM32MP157A Discovery Kit v1

Intro
=====

This configuration supports the STM32MP157 Discovery Kit 1 (DK1)
platform:

  https://www.st.com/en/evaluation-tools/stm32mp157a-dk1.html

How to build
============

 $ make stm32mp157a_dk1_defconfig
 $ make

How to write the microSD card
=============================

Once the build process is finished you will have an image called
"sdcard.img" in the output/images/ directory.

Copy the bootable "sdcard.img" onto an microSD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX

Boot the board
==============

 (1) Insert the microSD card in connector CN15

 (2) Plug a micro-USB cable in connector CN11 and run your serial
     communication program on /dev/ttyACM0.

 (3) Plug a USB-C cable in CN6 to power-up the board.

 (4) The system will start, with the console on UART, but also visible
     on the screen.
