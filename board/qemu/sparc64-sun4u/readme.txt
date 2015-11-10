Run the emulation with:

  qemu-system-sparc64 -M sun4u -kernel output/images/vmlinux -append "root=/dev/sda console=ttyS0,115200" -serial stdio output/images/rootfs.ext2 -net nic,model=e1000 -net user

The login prompt will appear in the terminal that started Qemu.

Tested with QEMU 2.3.0
