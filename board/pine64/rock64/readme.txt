Intro
=====

This default configuration will allow you to start experimenting with the
buildroot environment for the Rock64. With this default configuration you
can log in into board via uart and look around.

Board homepage: https://www.pine64.org/?page_id=7147

Build
=====

First, load rock64 config for buildroot

  $ make rock64_defconfig

Optionally make changes to buildroot config (to install more programs)

  $ make menuconfig

And then build everything

  $ make

When completed, following files will be generated in output/images directory:

  .
  ├── Image
  ├── bl31.bin
  ├── bl31.elf
  ├── rk3328-rock64.dtb
  ├── rootfs.ext2
  ├── rootfs.ext4 -> rootfs.ext2
  ├── rootfs.tar
  ├── sdcard.img
  ├── u-boot-spl.bin
  ├── u-boot-tpl-spl.img
  ├── u-boot-tpl.bin
  ├── u-boot-tpl.img
  ├── u-boot.bin
  └── u-boot.itb

Creating bootable SD card
=========================

!!! THIS COMMAND MAY WIPE YOUR DISK!
!!! MAKE SURE YOU PASSED CORRECT DEVICE!
!!! OR IT THIS WILL WIPE YOUR DISK!

Simply invoke (as root)

  # dd if=output/images/sdcard.img of=/dev/sdX && sync

Where X is your SD card device (not partition), of= argument may also be
/dev/mmcblk0 if you are using built-in sd card reader.

Runtime
=======

Login
-----

By default, buildroot has no password, just type 'root' as login user, and
you will be logged in.

Serial console
--------------

Serial console needs to be connected to pins (into 40pin rpi compatible part)

pin 6:  gnd
pin 8:  tx
pin 10: rx

Pin numbers are printed on board.

Uart configuration is not standard. Rock64 uses 1500000 (1,5M) baudrate
with standard 8n1.

Ethernet
--------

To enable ethernet you need to load modules for it:

# modprobe stmmac
# modprobe dwmac-rk

and since by default there is no dhcp installed, you need to configure ip
address, remember to change address to fit your network.

# ifconfig eth0 up
# ip addr add 10.1.1.180/24 dev eth0
# ping 10.1.1.1
PING 10.1.1.1 (10.1.1.1): 56 data bytes
64 bytes from 10.1.1.1: seq=0 ttl=64 time=0.695 ms
