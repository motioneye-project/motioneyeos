Run the emulation with:

 qemu-system-ppc -M mpc8544ds -kernel output/images/vmlinux -serial stdio -net nic,model=e1000 -net user

The login prompt will appear in the terminal that started Qemu.

Tested with QEMU 1.7.0
