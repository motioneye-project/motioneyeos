Run the emulation with:

  qemu-system-arm -M versatilepb -kernel output/images/zImage -drive file=output/images/rootfs.ext2,if=scsi -append "root=/dev/sda console=ttyAMA0,115200" -serial stdio

The login prompt will appear in the terminal that started Qemu. The
graphical window is the framebuffer.
