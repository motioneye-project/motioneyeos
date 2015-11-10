Run the emulation with:

  qemu-system-sh4eb -M r2d -kernel output/images/zImage -drive file=output/images/rootfs.ext2,if=ide -append "root=/dev/sda console=ttySC1,115200 noiotrap" -serial null -serial stdio -net nic,model=rtl8139 -net user

The login prompt will appear in the terminal that started Qemu.
The graphical window is the framebuffer.

Tested with QEMU 2.3.0
