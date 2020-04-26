Run the emulation with:

 qemu-system-mips64 -M malta -kernel output/images/vmlinux -serial stdio -drive file=output/images/rootfs.ext2,format=raw -append "rootwait root=/dev/hda" # qemu_mips64_malta_defconfig

The login prompt will appear in the terminal that started Qemu. The
graphical window is the framebuffer.
