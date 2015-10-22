Synopsys VDK Software Development Platform

Intro
=====

The Virtualizer Development Kit (VDK) Family for ARM Cortex Products
consists of a set of virtual prototypes that provide a virtualizer for
the ARM core variants. The VDK is a standalone package that runs on an
host computer.

Buildroot will generate the kernel image and a minimal root filesystem.

How to build it
===============

Configure Buildroot
-------------------

Configuring Buildroot is pretty simple, just execute:

  $ make snps_aarch64_vdk_defconfig

Build the rootfs and kernel
---------------------------

Note: you will need to have access to the network, since Buildroot will
download the packages' sources.

You may now build your rootfs with:

  $ make

(This may take a while)

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    -- rootfs.ext2
    -- Image

Installing your rootfs and Image
================================

Now copy the content of the output/images folder to the VDK' skins
folder:

   $ cp rootfs.ext2 Image <vdk_installation_path>/skins/Vanilla-Cortex/ARMv8


Starting the VDK
================================

Go the VDK' installation root and execute the 'start' script:

   $ cd <vdk_installation_path>
   $ ./start.sh

The VP Explorer application will be executed, starting the simulation
automatically.

For more information about Synopsys' VDK please check:
http://www.synopsys.com/Prototyping/VirtualPrototyping/Pages/default.aspx
