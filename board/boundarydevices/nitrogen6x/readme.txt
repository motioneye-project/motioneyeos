Buildroot for Boundary Devices Nitrogen6X:

http://boundarydevices.com/products/nitrogen6x-board-imx6-arm-cortex-a9-sbc/

Notice: U-Boot as shipped on the board has a bug reading rev 0 ext2
file systems (which is what genext2fs generates). To convert it to rev
1, do:

tune2fs -O filetype output/images/rootfs.ext2
e2fsck -a output/images/rootfs.ext2

To install, simply extract rootfs.ext2 to first partition of a uSD card:

sudo dd if=output/images/rootfs.ext2 of=/dev/sdX1

Where 'sdX1' is the device node of the uSD partition.
