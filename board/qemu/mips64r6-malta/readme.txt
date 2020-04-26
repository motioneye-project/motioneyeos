Run the emulation with:

 qemu-system-mips64 -M malta -cpu I6400 -kernel output/images/vmlinux -drive file=output/images/rootfs.ext2,format=raw -append "rootwait root=/dev/hda" -nographic # qemu_mips64r6_malta_defconfig

The login prompt will appear in the terminal that started Qemu.
