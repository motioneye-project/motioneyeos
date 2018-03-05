Vyasa RK3288
============

Vyasa is RK3288 based Single board computer with fully supported opensource software.

https://openedev.amarulasolutions.com/display/ODWIKI/Vyasa+RK3288

How to build it
===============

  $ make amarula_vyasa_rk3288_defconfig

Then you can edit the build options using

  $ make menuconfig

Compile all and build rootfs image:

  $ make

Prepare your SDCard
===================

Buildroot generates a ready-to-use SD card image that you can flash directly to
the card. The image will be in output/images/sdcard.img.
You can write this image directly to an SD card device (i.e. /dev/xxx):

  $ sudo dd if=output/images/sdcard.img of=/dev/xxx
  $ sudo sync

Finally, you can insert the SD card to the Vyasa RK3288 board, close J4 and boot it.
