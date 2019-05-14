import os

import infra.basetest


class TestAtop(infra.basetest.BRTest):
    config = \
        """
        BR2_arm=y
        BR2_cortex_a9=y
        BR2_ARM_ENABLE_NEON=y
        BR2_ARM_ENABLE_VFP=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_TARGET_GENERIC_GETTY_PORT="ttyAMA0"
        BR2_SYSTEM_DHCP="eth0"
        BR2_LINUX_KERNEL=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="4.16.7"
        BR2_LINUX_KERNEL_DEFCONFIG="vexpress"
        BR2_LINUX_KERNEL_DTS_SUPPORT=y
        BR2_LINUX_KERNEL_INTREE_DTS_NAME="vexpress-v2p-ca9"
        BR2_PACKAGE_ATOP=y
        BR2_TARGET_ROOTFS_CPIO=y
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def test_run(self):
        kernel = os.path.join(self.builddir, "images", "zImage")
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        dtb = os.path.join(self.builddir, "images", "vexpress-v2p-ca9.dtb")
        self.emulator.boot(arch="armv7", kernel=kernel, options=["-initrd", cpio_file, "-M", "vexpress-a9", "-dtb", dtb])
        self.emulator.login()

        cmd = "atop -V | grep '^Version'"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        cmd = "atop -a 1 2 | grep '% *atop *$'"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)
