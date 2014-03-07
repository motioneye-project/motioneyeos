Run the emulation with:

 qemu-system-mips64 -M malta -kernel output/images/vmlinux -serial stdio -hda output/images/rootfs.ext2 -append "root=/dev/hda"

The login prompt will appear in the terminal that started Qemu. The
graphical window is the framebuffer.

Tested with QEMU 1.7.0
