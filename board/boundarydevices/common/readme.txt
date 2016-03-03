Buildroot for Boundary Devices platforms:

https://boundarydevices.com/product-category/popular-sbc-and-som-modules/

Here is the list of targeted platforms per defconfig:

- nitrogen6x_defconfig
  - BD-SL-i.MX6 (SABRE-Lite)
  - Nitrogen6X
  - Nitrogen6_Lite
  - Nitrogen6_MAX
  - Nitrogen6_VM
  - Nitrogen6_SOM
  - Nitrogen6_SOMv2

- nitrogen6sx_defconfig
  - Nitrogen6_SoloX

- nitrogen7_defconfig
  - Nitrogen7

To install, simply copy the image to a uSD card:

$ sudo dd if=output/images/sdcard.img of=/dev/sdX

Where 'sdX' is the device node of the uSD partition.

To upgrade u-boot, cancel autoboot and type:

> run upgradeu
