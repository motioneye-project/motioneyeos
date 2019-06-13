Run with qemu:

For ck860 smp:
 qemu-system-cskyv2 -M virt -cpu ck860 -smp 2 -nographic -kernel vmlinux

For ck810/ck807:
 qemu-system-cskyv2 -M virt -nographic -kernel vmlinux

For ck610:
 qemu-system-cskyv1 -M virt -nographic -kernel vmlinux

The login prompt will appear in the terminal that started Qemu. Username is root and no password.
