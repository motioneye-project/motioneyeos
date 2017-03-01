How to get started with the MinnowBoard MAX
===========================================

1. Build

  Apply the defconfig:

  $ make minnowboard_max_defconfig

  Add any additional packages required and build:

  $ make

2. Write the SD card

  The build process will create a SD card image in output/images.
  Write the image to an mSD card, insert into the MinnowBoard MAX
  and power the board on.

  $ dd if=output/images/sdcard.img of=/dev/mmcblk0; sync

  The system starts two consoles: one on the serial port
  and one on HDMI.

3. Enjoy

Additional information about this board can be found at
http://www.minnowboard.org/.
