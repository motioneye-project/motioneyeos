Run the emulation with:

  qemu-system-ppc -M g3beige -kernel vmlinux -hda rootfs.ext2 -append "console=ttyS0 root=/dev/hdc" -serial stdio

The login prompt will appear in the terminal that started Qemu. The
graphical window is the framebuffer.
