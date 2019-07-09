****************************
Technexion i.MX7D Pico board
****************************

This file documents the Buildroot support for the Technexion i.MX7D Pico board.

Build
=====

First, configure Buildroot for the i.MX7D Pico board:

  make imx7dpico_defconfig

Build all components:

  make

You will find in output/images/ the following files:
  - imx7d-pico.dtb
  - rootfs.ext4
  - rootfs.tar
  - sdcard.img
  - u-boot-dtb.img
  - SPL
  - zImage

Flash U-Boot and SPL
=====

Note: This method is convenient for development purposes.
If the eMMC has already a U-Boot flashed with DFU support then
the user can go to step 2 below in order to update U-Boot.

Put pico board in USB download mode (refer to the PICO-iMX7D Quick Start Guide
page 3)

Connect a USB to serial adapter between the host PC and pico.

Connect a USB cable between the OTG pico port and the host PC.

Note: Some computers may be a bit strict with USB current draw and will
shut down their ports if the draw is too high. The solution for that is
to use an externally powered USB hub between the board and the host computer.

Open a terminal program such as minicom.

Copy SPL and u-boot-dtb.img to the imx_usb_loader folder.

Load the SPL binary via USB:

$ sudo ./imx_usb SPL

Load the u-boot-dtb.img binary via USB:

$ sudo ./imx_usb u-boot-dtb.img

Then U-Boot starts and its messages appear in the console program.

Use the default environment variables:

=> env default -f -a
=> saveenv

Run the DFU agent so we can flash the new images using dfu-util tool:

=> dfu 0 mmc 0

Flash SPL and u-boot-dtb.img into the eMMC running the following commands on a PC:

$ sudo dfu-util -D SPL -a spl

$ sudo dfu-util -D u-boot-dtb.img -a u-boot

Remove power from the pico board.

Put pico board into normal boot mode.

Power up the board and the new updated U-Boot should boot from eMMC.

Flash the eMMC
==============

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

*** WARNING! This will destroy all the eMMC content. Use with care! ***

For details about the medium image layout, see the definition in
board/freescale/common/imx/genimage.cfg.template.

Boot the i.MX7D Pico board
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
