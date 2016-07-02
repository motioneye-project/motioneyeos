Run the emulation with:

  qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -smp 1 -kernel output/images/Image -append "console=ttyAMA0" -netdev user,id=eth0 -device virtio-net-device,netdev=eth0

The login prompt will appear in the terminal that started Qemu.

Tested with QEMU 2.6.0
