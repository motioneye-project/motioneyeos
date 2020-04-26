Run the emulation with:

 qemu-system-mips64el -M malta -kernel output/images/vmlinux -serial stdio -drive file=output/images/rootfs.ext2,format=raw -append "rootwait root=/dev/hda" # qemu_mips64el_malta_defconfig

The login prompt will appear in the terminal that started Qemu. The
graphical window is the framebuffer.
