Acme Systems Aria G25

Build instructions
==================

To build an image for the Aria G25 choose the configuration
corresponding to the Aria variant.

For 128MB RAM variant type:

$ make acmesystems_aria_g25_128mb_defconfig

else for 256MB RAM variant type:

$ make acmesystems_aria_g25_256mb_defconfig

To customize the configuration choosed type:

$ make menuconfig

When you are ready to start building Buildroot type:

$ make

How to write the microSD card
=============================

Once the build process is finished you will have an image called
"sdcard.img" in the output/images/ directory.

Write the bootable SD card image "sdcard.img" onto an SD card with
"dd" command:

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX

Assuming your Aria G25 baseboard has a MicroSD socket, for example
with the Terra baseboard, insert the microSD card into the baseboard
slot and power it.

To get the kernel log messages you can use a DPI cable
(http://www.acmesystems.it/DPI)

You can find additional informations, tutorials and a very
comprehensive documentation on http://www.acmesystems.it/aria.
