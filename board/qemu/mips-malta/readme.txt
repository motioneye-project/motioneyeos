Run the emulation with:

 qemu-system-mips -M malta -kernel output/images/vmlinux -serial stdio -hda output/images/rootfs.ext2 -append "root=/dev/hda" -net nic,model=pcnet -net user

The login prompt will appear in the terminal that started Qemu. The
graphical window is the framebuffer. No keyboard support has been
enabled.

Tested with QEMU 1.5.2
