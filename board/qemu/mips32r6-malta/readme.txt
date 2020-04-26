Run the emulation with:

 qemu-system-mips -M malta -cpu mips32r6-generic -kernel output/images/vmlinux -drive file=output/images/rootfs.ext2,format=raw -append "rootwait root=/dev/hda" -nographic # qemu_mips32r6_malta_defconfig

The login prompt will appear in the terminal that started Qemu.
