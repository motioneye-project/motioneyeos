Run the emulation with:

  qemu-system-arm -M nuri -kernel output/images/zImage -append "console=ttySAC1,115200" -smp 2 -serial null -serial stdio

The login prompt will appear in the terminal that started Qemu. The
graphical window is the framebuffer.

Startup time is slow because of the SMP CPU emulation so be patient.

Tested with QEMU 2.1.2
