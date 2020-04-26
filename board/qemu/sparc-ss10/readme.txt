Run the emulation with:

  qemu-system-sparc -M SS-10 -kernel output/images/zImage -drive file=output/images/rootfs.ext2,format=raw -append "rootwait root=/dev/sda console=ttyS0,115200" -serial stdio -net nic,model=lance -net user # qemu_sparc_ss10_defconfig

The login prompt will appear in the terminal that started Qemu.
