Buildroot board support for Telit EVK-PRO3 with Telit GE863-PRO3

Official site:
  http://www.telit.com/en/products.php?p_id=3&p_ac=show&p=10

Build images:
    make telit_evk_pro3_defconfig
    make

  images built:
  - output/images/barebox.bin
  - output/images/zImage
  - output/images/rootfs.ubi


Flash built images:
  The first time you need to bootstrap from Telit Official Release 221.07.1007,
  at the U-Boot prompt type:
    U-Boot> loadb
  send buildroot/output/images/barebox.bin
    U-Boot> go 0x20200000

  flash updated images using barebox through tftp:
    barebox:/ erase dev/self0; cp /mnt/tftp/barebox.bin /dev/self0
    barebox:/ erase /dev/nand0.kernel.bb; cp /mnt/tftp/zImage /dev/nand0.kernel.bb
    barebox:/ erase /dev/nand0.rootfs.bb; cp /mnt/tftp/rootfs.ubi /dev/nand0.rootfs.bb
    barebox:/ erase dev/env0
    barebox:/ reset
