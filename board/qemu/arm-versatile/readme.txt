Run the emulation with:

  qemu-system-arm -M versatilepb -kernel output/images/zImage -dtb output/images/versatile-pb.dtb -drive file=output/images/rootfs.ext2,if=scsi,format=raw -append "root=/dev/sda console=ttyAMA0,115200" -serial stdio -net nic,model=rtl8139 -net user

Or for the noMMU emulation:

  qemu-system-arm -M versatilepb -kernel output/images/zImage -append "console=ttyAMA0,115200" -serial stdio -net user -net nic,model=smc91c111

The login prompt will appear in the terminal that started Qemu. The
graphical window is the framebuffer.

Tested with QEMU 2.5.0
