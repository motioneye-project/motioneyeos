Amarula A64 Relic
================

Amarula A64-Relic is an Allwinner A64 based IoT device, which supports:
- Allwinner A64 Cortex-A53
- Mali-400MP2 GPU
- AXP803 PMIC
- 1GB DDR3 RAM
- 8GB eMMC
- AP6330 Wifi/BLE
- MIPI-DSI
- CSI: OV5640 sensor
- USB OTG
- 12V DC power supply

Wiki link:
https://openedev.amarulasolutions.com/display/ODWIKI/Amarual+A64-Relic

Build
=====

  $ make amarula_a64_relic_defconfig

  $ make

build files at output/images/:
  - sunxi-spl.bin
  - u-boot.itb
  - Image
  - sun50i-a64-amarula-relic.dtb
  - boot.vfat
  - rootfs.ext4

Write eMMC
=========

The board comes with an operating system preloaded on the eMMC.
To replace it with the Buildroot-built system, take the following
steps

1. Connect the board UART with host and open minicom(ttyUSBx/115200N8)

2. Supply 12V DC for power-on the board.

3. Interrupt U-Boot by pressing enter

4. Create GPT partitions
  => mmc dev 1
  => gpt write mmc 1 $partitions

5. Connect the board USB-OTG with USB slot on the host.

6. Initiate fastboot
  => fastboot 0

7. Write images from host onto eMMC using fastboot
  $ cd output/images
  $ sudo fastboot -i 0x1f3a flash loader1 sunxi-spl.bin
  $ sudo fastboot -i 0x1f3a flash loader2 u-boot.itb
  $ sudo fastboot -i 0x1f3a flash esp boot.vfat
  $ sudo fastboot -i 0x1f3a flash system rootfs.ext4

Update eMMC during Development
==============================

During development, reflashing the entire filesystem image at every
change is time consuming. A useful alternative is to directly access
over USB the filesystem stored on the eMMC, using the USB Mass Storage
capability of U-Boot. To achieve this:

1. Build U-Boot by enabling UMS
   $ make uboot-menuconfig
   (select CONFIG_CMD_USB_MASS_STORAGE=y)

2. Follow all 6 steps from 'Write eMMC' and mount eMMC on host
    => mmc dev 1
    => ums 0 mmc 1

WiFi
====

 # wpa_passphrase ACCESSPOINTNAME >> /etc/wpa_supplicant.conf
   (type password and enter)
 # wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf -B
 # udhcpc -i wlan0
 # ping google.com

--
Jagan Teki <jagan@amarulasolutions.com>
29-Jun-2018
