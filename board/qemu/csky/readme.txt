Run with qemu:

For ck860 smp:
 qemu-system-cskyv2 -M virt -cpu ck860 -smp 2 -nographic -kernel vmlinux # qemu_csky860_virt_defconfig

For ck807:
 qemu-system-cskyv2 -M virt -nographic -kernel vmlinux # qemu_csky807_virt_defconfig

For ck810:
 qemu-system-cskyv2 -M virt -nographic -kernel vmlinux # qemu_csky810_virt_defconfig

For ck610:
 qemu-system-cskyv1 -M virt -nographic -kernel vmlinux # qemu_csky610_virt_defconfig

The login prompt will appear in the terminal that started Qemu. Username is root and no password.
