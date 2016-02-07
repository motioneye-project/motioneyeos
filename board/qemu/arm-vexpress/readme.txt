Run the emulation with:

  qemu-system-arm -M vexpress-a9 -smp 1 -m 256 -kernel output/images/zImage -dtb output/images/vexpress-v2p-ca9.dtb -drive file=output/images/rootfs.ext2,if=sd,format=raw -append "console=ttyAMA0,115200 root=/dev/mmcblk0" -serial stdio -net nic,model=lan9118 -net user

The login prompt will appear in the terminal that started Qemu. The
graphical window is the framebuffer.

If you want to emulate more cores change "-smp 1" to "-smp 2" for
dual-core or even "smp -4" for a quad-core configuration.

Tested with QEMU 2.3.0
