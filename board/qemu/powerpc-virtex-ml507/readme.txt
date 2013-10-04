Run the emulation with:

 cp output/images/virtex440-ml507.dtb ppc.dtb
 qemu-system-ppc -M virtex-ml507 -kernel output/images/vmlinux -m 256 -nographic -append "console=ttyS0"

The login prompt will appear in the terminal that started Qemu.

Tested with QEMU 1.6.0
