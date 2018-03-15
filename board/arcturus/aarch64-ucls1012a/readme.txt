Arcturus uCLS1012A SoM
======================

This tutorial describes how to use the predefined Buildroot
configuration for the Arcturus uCLS101A SoM platform.

Additional information about the uCLS1012A System on Module can be found at
https://www.arcturusnetworks.com/products/ucls1012a
and product support for registered users at
https://www.arcturusnetworks.com/support

Building
--------

Return to the top directory <buildrootdir> and execute the following commands.

  make arcturus_ucls1012a_defconfig
  make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    +-- arc-ucls1012a.dtb
    +-- Image
    +-- part0-000000.itb
    +-- rootfs.cpio
    +-- rootfs.cpio.gz
    +-- rootfs.tar
    +-- u-boot.bin
    +-- ucls1012a.its

Flashing
--------

You'll need to program the image created by buildroot into the SPI NOR flash.

1. Reboot your module and via the serial console press <escape> to enter the B$
u-boot shell.
   From the shell you will need to update four environment variables replacing the
   IPv4 IP Address with ones that will work with your network and tftp server.

   B$ setenv ipaddr 192.168.1.81
   B$ setenv serverip 192.168.1.80
   B$ setenv gatewayip 192.168.1.1
   B$ setenv netmask 255.255.255.0
   B$ saveenv

2. Enable tftp server to serve the <buildrootdir>/output/images/ folder.

3. Program the new U-Boot binary (optional)
    If you don't feel confident upgrading your bootloader then don't do it,
    it's unnecessary most of the time.

    B$ tftp u-boot.bin
    B$ run program_uboot

4. Program the ITB image (includes Kernel, DTB and Ramdisk)

    B$ tftp part0-000000.itb
    B$ run iprogram

5. Booting your new system

    Reboot your system by reset command
    B$ reset

        or

    B$ run bootcmd

Good Luck !
