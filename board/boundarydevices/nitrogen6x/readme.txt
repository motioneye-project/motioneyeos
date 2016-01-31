Buildroot for Boundary Devices Nitrogen6X:

http://boundarydevices.com/products/nitrogen6x-board-imx6-arm-cortex-a9-sbc/

To install, simply copy the image to a uSD card:

sudo dd if=output/images/sdcard.img of=/dev/sdX

Where 'sdX' is the device node of the uSD partition.

To upgrade u-boot, cancel autoboot and type:

run upgradeu
