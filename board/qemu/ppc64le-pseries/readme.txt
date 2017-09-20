Run the emulation with:

qemu-system-ppc64le -M pseries -nographic \
		-kernel output/images/vmlinux \
		-initrd output/images/rootfs.ext2

The login prompt will appear in the terminal window.

Tested with QEMU 2.10.0
