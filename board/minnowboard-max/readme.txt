How to get started with the Minnow Board MAX
============================================

1. Build

  Apply the defconfig:

  $ make minnowboard_max_defconfig

  Add any additional packages required and build:

  $ make

2. Write the SD card

  The build process will create a SD card image in output/images.
  Write the image to an mSD card, insert into the Minnowboard MAX
  and power the board on.

  $ dd if=output/images/sdcard.img of=/dev/mmcblk0; sync

3. Enjoy

Additional information about this board can be found at
http://www.minnowboard.org/ or http://wiki.minnowboard.org/MinnowBoard_MAX
