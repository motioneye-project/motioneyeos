*********************************************
Buildroot for Engicam i.CoreM6 SOM platforms:
*********************************************

This file documents the Buildroot support for Engicam i.CoreM6
platform boards.

i.CoreM6 Quad/Dual/DualLite/Solo SOM Starter kits:
https://www.engicam.com/vis-prod/101120
i.CoreM6 Quad/Dual/DualLite/Solo Open Frame 10.1 C.TOUCH kits:
https://www.engicam.com/vis-prod/101133

This configuration uses U-Boot mainline and kernel mainline.

Build
=====

First, configure Buildroot for the Engicam i.CoreM6:

  make engicam_imx6qdl_icore_defconfig

Build all components:

  make

You will find the following files in output/images/:
  - imx6q-icore.dtb (for i.CoreM6 Quad/Dual)
  - imx6dl-icore.dtb (for i.CoreM6 DualLite/Solo)
  - imx6q-icore-ofcap10.dtb (for i.CoreM6 Quad/Dual ofcap 10)
  - imx6q-icore-ofcap12.dtb (for i.CoreM6 Quad/Dual ofcap 12)
  - rootfs.ext4
  - rootfs.tar
  - sdcard.img
  - SPL
  - u-boot-dtb.img
  - uImage

Create a bootable SD card
=========================

To determine the device associated to the SD card have a look in the
/proc/partitions file:

  cat /proc/partitions

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on a SD card. Launch the following
command as root:

  dd if=output/images/sdcard.img of=/dev/<your-sd-device>
  sync

*** WARNING! This will destroy all the card content. Use with care! ***

For details about the medium image layout, see the definition in
board/engicam/icorem6/genimage.cfg

Boot the i.CoreM6 boards with SD boot:
=====================================

To boot your newly created system:
- insert the SD card in the SD slot of the board;
- connect 3-wire RS232 serial port J28 on board, and connect with other
  serial end or USB cable(if serial-to-usb converter used) using
  a terminal emulator at 115200 bps, 8n1;
- close JM3 for sd boot.
- power on the board.

Testing graphics on i.CoreM6:
============================

Build with support for Etnaviv, Qt5 and demo applications:

  make engicam_imx6qdl_icore_qt5_defconfig
  make

Running kmscube
# kmscube -D /dev/dri/card1

Running glmark2-es2-drm
# glmark2-es2-drm

Running Qt5 Cinematic Demo:
- for i.CoreM6 Starter Kit
# export QT_QPA_EGLFS_KMS_CONFIG=/root/imx6qdl-icore.json
- for i.CoreM6 ofcap10
# export QT_QPA_EGLFS_KMS_CONFIG=/root/imx6qdl-icore-ofcap10.json
- for i.CoreM6 ofcap12
# export QT_QPA_EGLFS_KMS_CONFIG=/root/imx6qdl-icore-ofcap12.json

# CinematicExperience-demo

Enjoy!
