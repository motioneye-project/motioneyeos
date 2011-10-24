Run the emulation with:

  qemu-system-sh4 -M r2d -kernel output/images/zImage -drive file=output/images/rootfs.ext2,if=ide -append "root=/dev/sda noiotrap"

The login prompt will appear in the graphical window.
