Run the emulation with:

  qemu-system-sparc64 -M sun4u -kernel output/images/vmlinux -append "rootwait root=/dev/sda console=ttyS0,115200" -serial stdio -drive file=output/images/rootfs.ext2,format=raw -net nic,model=e1000 -net user # qemu_sparc64_sun4u_defconfig

The login prompt will appear in the terminal that started Qemu.
