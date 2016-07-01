Run the emulation with:

 qemu-system-mips64el -M malta -cpu MIPS64R6-generic -kernel output/images/vmlinux -drive file=output/images/rootfs.ext2,format=raw -append "root=/dev/hda" -nographic

The login prompt will appear in the terminal that started Qemu.

Tested with QEMU 2.6.0
