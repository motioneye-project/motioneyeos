Banana Pro

Intro
=====

This default configuration will allow you to start experimenting with the
Buildroot environment for the Banana Pro. With the current configuration
it will bring-up the board, and allow access through the serial console.

How to build it
===============

Configure Buildroot:

  $ make bananapro_defconfig

Compile everything and build the SD card image:

  $ make

How to write the SD card
========================

Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ dd if=output/images/sdcard.img of=/dev/sdX

Notes:
  - replace 'sdX' with the actual device with your micro SD card
  - you may need to be root to do that (use 'sudo')

Insert the micro SD card in your Banana Pro and power it up. The console
is on the debug TTL UART, 115200 8N1.

Ethernet
==========

  # udhcpc -i eth0

Wifi
==========

  # wpa_passphrase YOUR_SSID >> /etc/wpa_supplicant.conf
  (enter the wifi password and press enter)
  # wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf -B
  # udhcpc -i wlan0

Note:
  - replace 'YOUR_SSID' with the actual SSID from your access point

Audio
==========

Connect a headphone to the 3.5mm jack (TRRS). Note, that the Banana Pro
has an on-board microphone, too.

  # amixer cset name='Power Amplifier DAC Playback Switch' on
  # amixer cset name='Power Amplifier Mute Switch' on
  # amixer cset name='Power Amplifier Volume' 42
