NXP i.MX6SL EVK board
---------------------

To build a minimal support for this board:

$ make imx6slevk_defconfig
$ make

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be flashed into the SD card:

$ sudo dd if=output/images/sdcard.img of=/dev/<sd-card-device>; sync

Then insert the SD card into the SD2 slot and boot the board.
