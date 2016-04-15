STM32F429 Discovery
===================

This tutorial describes how to use the predefined Buildroot
configuration for the STM32F429 Discovery evaluation platform.

Building
--------

  make stm32f429_disco_defconfig
  make

Wire the UART
-------------

Use a USB to TTL adapter, and connect:

 - RX to PA9
 - TX to PA10
 - GND to one of the GND available on the board

The UART is configured at 115200.

Flashing
--------

  ./board/stmicroelectronics/stm32f429-disco/flash.sh output/

It will flash the minimal bootloader, the Device Tree Blob, and the
kernel image which includes the root filesystem as initramfs.
