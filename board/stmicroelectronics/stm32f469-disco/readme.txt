STM32F469 Discovery
===================

This tutorial describes how to use the predefined Buildroot
configuration for the STM32F469 Discovery evaluation platform.

Building
--------

  make stm32f469_disco_defconfig
  make

Flashing
--------

  ./board/stmicroelectronics/stm32f469-disco/flash.sh output/

It will flash the minimal bootloader, the Device Tree Blob, and the
kernel image which includes the root filesystem as initramfs.
