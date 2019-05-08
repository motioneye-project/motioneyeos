Introduction
============

Armadeus APFxx are Systems On Module (SOM) based on Freescale/NXP i.MX
processors associated with an FPGA (except on APF28). Non volatile
data are stored in on-module NOR or NAND Flash, depending on the
model. These SOM can be used on Armadeus development boards or with
custom docking boards.

Supported platforms
===================

Buildroot currently supports the following Armadeus platforms with the
associated defconfigs:

 * APF27 SOM + devt board    -> armadeus_apf27_defconfig
 * APF51 SOM + devt board    -> armadeus_apf51_defconfig
 * APF28 SOM + devt board    -> armadeus_apf28_defconfig

Vanilla Linux versions are preferred to Freescale's one in these
configurations.

How to build it
===============

Configure Buildroot
-------------------

Let's say you own an APFxx SOM with it's corresponding development
board, all you have to do is:

  $ make armadeus_apfxx_defconfig

where "apfxx" is the version of your SOM.

Launch build
------------

  $ make

Result of the build
-------------------

When the build is finished, you will end up with:

    output/images/
    +-- imx**-apfxxdev.dtb	[1]
    +-- rootfs.tar
    +-- rootfs.ubi
    +-- rootfs.ubifs
    +-- uImage

[1] Only if the kernel version used uses a Device Tree.

Building U-Boot is currently not supported in these configurations.

Installation
============

You will require a serial connection to the board and a TFTP server on
your Host PC. Assuming your server is configured for exporting
/tftpboot/ directory, you will have to copy the generated images to
it:

  $ cp output/images/uImage /tftpboot/apfxx-linux.bin
  $ cp output/images/*.dtb /tftpboot/
  $ cp output/images/rootfs.ubi /tftpboot/apfxx-rootfs.ubi

where "apfxx" is the version of your SOM, as used with _defconfigs.

Then on your serial terminal, all you have to do is:

* interrupt the boot process and access U-Boot console by pressing any
  key when booting,
* configure board and server IP addresses with "ipaddr" and "serverip"
  environment variables,
* if you want to update kernel:
  BIOS > run update_kernel
* if you want to update device tree:
  BIOS > run update_dtb
* if you want to update rootfs:
  BIOS > run update_rootfs

That's it !
