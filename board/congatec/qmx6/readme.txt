This is the minimal buildroot support for the Congatec QMX6 Qseven CoM

conga-QMX6 is based on the freescale iMX6 SoC. For more information please
have a look at http://www.congatec.com/products/qseven/conga-qmx6.html

The configuration is based on the currently latest kernel release from
Congatec's git repository which is based on 3.0.35. The bootloader u-boot
is preconfigured on the CPU module and does not need to be replaced.

To build the default configuration you only have to:

	make qmx6_defconfig && make

You will need a microSD card of sufficient size and the first or only
partition configured as Linux type.

To transfer the system to the card do:

	$ sudo dd if=output/images/rootfs.ext2 of=/dev/sdX1

You can optionally extend the filesystem size to the whole partition:

	$ sudo resize2fs /dev/sdX1

You can also update the card image without completely rewriting it:

	$ sudo mount /dev/sdX1 /mnt
	$ sudo tar xf output/images/rootfs.tar -C /mnt
	$ sudo umount /mnt

Connect a terminal program to the rs232 connector marked "CONSOLE"
with baudrate set to 115200, insert the microSD card into the socket
on the CPU module and power the board to watch the system boot.

Booting from the SD card slot on the base board is currently not
supported.
