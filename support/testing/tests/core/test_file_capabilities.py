import os
import subprocess

import infra.basetest


class TestFileCapabilities(infra.basetest.BRTest):
    config = \
        """
        BR2_arm=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_ROOTFS_DEVICE_TABLE="system/device_table.txt {}"
        BR2_ROOTFS_DEVICE_TABLE_SUPPORTS_EXTENDED_ATTRIBUTES=y
        BR2_TARGET_GENERIC_GETTY_PORT="ttyAMA0"
        BR2_LINUX_KERNEL=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="4.11.3"
        BR2_LINUX_KERNEL_DEFCONFIG="vexpress"
        BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES="{}"
        BR2_LINUX_KERNEL_DTS_SUPPORT=y
        BR2_LINUX_KERNEL_INTREE_DTS_NAME="vexpress-v2p-ca9"
        BR2_PACKAGE_LIBCAP=y
        BR2_PACKAGE_LIBCAP_TOOLS=y
        BR2_TARGET_ROOTFS_SQUASHFS=y
        # BR2_TARGET_ROOTFS_TAR is not set
        """.format(infra.filepath("tests/core/device_table2.txt"),
                   infra.filepath("tests/core/squashfs-xattr-kernel.config"))

    def test_run(self):
        img = os.path.join(self.builddir, "images", "rootfs.squashfs")
        subprocess.call(["truncate", "-s", "%1M", img])

        self.emulator.boot(arch="armv7",
                           kernel=os.path.join(self.builddir, "images", "zImage"),
                           kernel_cmdline=["root=/dev/mmcblk0",
                                           "rootfstype=squashfs"],
                           options=["-drive", "file={},if=sd,format=raw".format(img),
                                    "-M", "vexpress-a9",
                                    "-dtb", os.path.join(self.builddir, "images", "vexpress-v2p-ca9.dtb")])
        self.emulator.login()

        cmd = "getcap -v /usr/sbin/getcap"
        output, _ = self.emulator.run(cmd)
        self.assertIn("cap_kill", output[0])
        self.assertIn("cap_sys_nice", output[0])
        self.assertIn("cap_sys_time", output[0])
        self.assertIn("+eip", output[0])
