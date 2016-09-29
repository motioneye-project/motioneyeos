*****************
Warp i.MX7S board
*****************

This file documents the Buildroot support for the Warp i.MX7S board.

Build
=====

First, configure Buildroot for the Warp i.MX7S board:

  make warp7_defconfig

Build all components:

  make

You will find in output/images/ the following files:
  - imx7s-warp.dtb
  - rootfs.ext4
  - rootfs.tar
  - sdcard.img
  - u-boot.imx
  - zImage

Flash the eMMC image
====================

In the U-Boot prompt lauch:

=> ums 0 mmc 0

This will mount the eMMC content in the host PC as a mass storage device.

To determine the device associated to the eMMC have a look in the
/proc/partitions file:

  cat /proc/partitions

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped into the eMMC. Launch the following
command:

sudo dd if=output/images/sdcard.img of=/dev/<your-emmc-device>

*** WARNING! This will destroy all the eMMC content. Use it with care! ***

For details about the medium image layout, see the definition in
board/warp7/genimage.cfg.

How to recover from a bad eMMC image
====================================

In case a bad U-Boot has been flashed to the eMMC and the board no
longer boots, it is possible to recover using the imx_usb_loader utility.

Put the warp7 board in USB download mode by removing the CPU board
from the base board then putting switch 2 in the upper position.

Connect a USB to serial adapter between the host PC and warp7 serial
USB port, and also a USB cable between the OTG warp7 port and the host
PC.

Copy u-boot.imx to the imx_usb_loader folder.

Load u-boot.imx via USB:

$ sudo ./imx_usb u-boot.imx

Then U-Boot should start and its messages will appear in the console program.

Open a terminal program such as minicom.

Use the default environment variables:

=> env default -f -a
=> saveenv
=> ums 0 mmc 0

sudo dd if=output/images/sdcard.img of=/dev/<your-emmc-device>

Put warp7 back in eMMC boot mode by placing switch 2 in the lower position
and reboot the board.

Boot the Warp i.MX7S board
==========================

To boot your newly created system:
- put a micro USB cable into the Debug USB Port and connect using a terminal
  emulator at 115200 bps, 8n1;
- power on the board.

Using Wifi
==========

# modprobe brcmfmac
# iwconfig wlan0 essid ACCESSPOINTNAME
# wpa_passphrase ACCESSPOINTNAME > /etc/wpa.conf
(enter the wifi password and press enter)
# wpa_supplicant -Dwext -iwlan0 -c /etc/wpa.conf &
# udhcpc -i wlan0
# ping buildroot.org

Enjoy!
