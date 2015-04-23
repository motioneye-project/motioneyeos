Buildroot for Boundary Devices Nitrogen6X:

http://boundarydevices.com/products/nitrogen6x-board-imx6-arm-cortex-a9-sbc/

To install, simply write rootfs.ext2 to the first partition of a uSD card:

sudo dd if=output/images/rootfs.ext2 of=/dev/sdX1

Where 'sdX1' is the device node of the uSD partition.

To upgrade u-boot, cancel autoboot and type:

run upgradeu
