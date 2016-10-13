Run the emulation with:

 qemu-system-mips64el -M malta -cpu I6400 -kernel output/images/vmlinux -drive file=output/images/rootfs.ext2,format=raw -append "root=/dev/hda" -nographic

The login prompt will appear in the terminal that started Qemu.

Tested with QEMU 2.6.0

Might work with 2.6.0 by changing the -cpu entry to MIPS64R6-generic
since the naming was updated and the old name removed in 2.7.0
