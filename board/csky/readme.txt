C-SKY Development Kit

Intro
=====

C-SKY is a CPU Architecture from www.c-sky.com and has it own instruction set.
Just like arm and mips in linux/arch, it named as 'csky'.

gx6605s develop board is made by Hangzhou Nationalchip and C-SKY.

Hardware Spec:
  * CPU: ck610 up to 594Mhz
  * Integrate with 64MB ddr2 in SOC.
  * Integrate with hardware Jtag.
  * Integrate with usb-to-serial chip.
  * USB ehci controller in SOC.
  * Power Supply: DC 5V from two micro-usb.

How to build it
===============

Configure Buildroot
-------------------

The csky_gx6605s_defconfig configuration is a sample configuration with
all that is required to bring the gx6605s Development Board:

  $ make csky_gx6605s_defconfig

Build everything
----------------

Note: you will need to have access to the network, since Buildroot will
download the packages' sources.

  $ make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── vmlinux
    ├── rootfs.ext2
    └── <board name>.dtb

How to run it
=============

Prepare Jtag-Server
-------------------

  Download the Jtag-Server here:

  https://github.com/c-sky/tools/raw/master/DebugServerConsole-linux-x86_64-V4.2.00-20161213.tar.gz

  Go to the unpacked directory:

  $./DebugServerConsole -ddc -rstwait 1000 -prereset -port 1025

  Perhaps you need to use "sudo", which need libusb to detect c510:b210

  $ sudo ./DebugServerConsole -ddc -rstwait 1000 -prereset -port 1025

Prepare USB drive
-----------------

  You sould determine which device associated to the usb drive
  carefully. eg:

  $ cat /proc/partitions
   8       48    1971712 sdd
   8       49     976720 sdd1

  $ sudo dd if=rootfs.ext2 of=/dev/sdd1
  $ sudo sync

Run
---

  Plug the usb drive on gx6605s dev board.

  Setup the Console with the rate 115200/8-N-1.

  $ cd output/images
  $ ../host/usr/bin/csky-linux-gdb -x ../../board/csky/gx6605s/gdbinit vmlinux

