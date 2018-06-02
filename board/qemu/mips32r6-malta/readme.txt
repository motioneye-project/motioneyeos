Run the emulation with:

qemu-system-mips -M malta -cpu mips32r6-generic -kernel output/images/vmlinux -drive file=output/images/rootfs.ext2,format=raw -append "root=/dev/hda" -nographic

The login prompt will appear in the terminal that started Qemu.

Tested with QEMU 2.12.0
