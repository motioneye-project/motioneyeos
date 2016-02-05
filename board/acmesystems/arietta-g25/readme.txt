Acmesystems Arietta G25

Intro
=====

This default configuration will allow you to start experimenting with the
buildroot environment for the Arietta G25. With the current configuration
it will bring-up the board, and allow access through the serial console.

You can find additional informations, tutorials and a very comprehensive
documentation on http://www.acmesystems.it/arietta.

Build instructions
==================

To build an image for the arietta g25 choose the configuration
corresponding to the arietta variant.

For 128MB RAM variant type:

$ make acmesystems_arietta_g25_128mb_defconfig

else for 256MB RAM variant type:

$ make acmesystems_arietta_g25_256mb_defconfig

then:

$ make

How to write the microSD card
=============================

Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX

Insert the microSD card into the arietta slot and power it.

The image just built is fairly basic and the only output
you will get is on serial console, please consider to use a DPI
cable (http://www.acmesystems.it/DPI)
