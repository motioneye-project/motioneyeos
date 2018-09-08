Buildroot for Embest RIoTboard
==============================

This is a small development board, based on Freescale IMX6 Solo SoC
(single core ARM Cortex-A9).

More details about the board can be found at:

  http://www.embest-tech.com/riotboard

1. Compiling buildroot
----------------------

$ make riotboard_defconfig
$ make

2. Installing buildroot
-----------------------

Prepare an SD-card and plug it into your card reader. Always double
check the block device before writing to it, as writing to the wrong
block device can cause irrecoverable data loss. Now you can write the
image to your SD-card:

sudo dd if=output/images/sdcard.img of=/dev/<sdcard-block-device> bs=1M

3. Running buildroot
--------------------

Position the board so you can read the label "RIoTboard" on the right
side of SW1 DIP switches. Configure the SW1 swiches like this:

1   0  1   0   0  1   0  1
ON OFF ON OFF OFF ON OFF ON

Now plug your prepared SD-card in slot J6. Connect a serial console
(115200, 8, N, 1) to header J18. Connect a 5V/1A power supply to the
board and enjoy.
