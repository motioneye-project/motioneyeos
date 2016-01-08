Run the emulation with:

  qemu-system-i386 -M pc -kernel output/images/bzImage -drive file=output/images/rootfs.ext2,if=ide,format=raw -append root=/dev/sda -net nic,model=rtl8139 -net user

Optionally add -smp N to emulate a SMP system with N CPUs.

The login prompt will appear in the graphical window.

Tested with QEMU 2.3.0
