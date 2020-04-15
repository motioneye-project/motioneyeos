Buildroot for Boundary Devices platforms:

https://boundarydevices.com/nitrogen-sbcs-and-soms/

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

- nitrogen8m_defconfig
  - Nitrogen8M
  - Nitrogen8M_SOM

- nitrogen8mm_defconfig
  - Nitrogen8MMini
  - Nitrogen8MMini_SOM

- nitrogen8mn_defconfig
  - Nitrogen8MNano
  - Nitrogen8MNano_SOM

To install, simply copy the image to your storage (SD, eMMC, USB):

$ sudo dd if=output/images/sdcard.img of=/dev/sdX

Where 'sdX' is the device node of the uSD partition.

To upgrade u-boot, cancel autoboot and type:

> run upgradeu
