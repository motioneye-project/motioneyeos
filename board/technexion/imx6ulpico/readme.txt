*****************************
Technexion i.MX6UL Pico board
*****************************

This file documents the Buildroot support for the Technexion i.MX6UL Pico board.

Build
=====

First, configure Buildroot for the i.MX6UL Pico board:

  make imx6ulpico_defconfig

Build all components:

  make

You will find in output/images/ the following files:
  - imx6ul-pico-hobbit.dtb
  - rootfs.ext4
  - rootfs.tar
  - sdcard.img
  - u-boot.imx
  - zImage

Create a bootable SD card
=========================

In the U-Boot prompt lauch:

=> ums 0 mmc 0

This will mount the eMMC content in the host PC as a mass storage device.

To determine the device associated to the eMMC card have a look in the
/proc/partitions file:

  cat /proc/partitions

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on the eMMC card. Launch the following
command as root:

  dd if=output/images/sdcard.img of=/dev/<your-sd-device>

*** WARNING! This will destroy all the card content. Use with care! ***

For details about the medium image layout, see the definition in
board/freescale/common/imx/genimage.cfg.template.

Boot the i.MX6UL Pico board
=========================

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
