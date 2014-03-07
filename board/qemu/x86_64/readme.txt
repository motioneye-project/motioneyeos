Run the emulation with:

  qemu-system-x86_64 -M pc -kernel output/images/bzImage -drive file=output/images/rootfs.ext2,if=ide -append root=/dev/sda -net nic,model=rtl8139 -net user

The login prompt will appear in the graphical window.

Tested with QEMU 1.7.0
