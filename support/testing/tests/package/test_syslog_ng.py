import os

import infra.basetest


class TestSyslogNg(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_LINUX_KERNEL=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="4.19.16"
        BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG=y
        BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="board/qemu/arm-versatile/linux.config"
        BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES="{}"
        BR2_LINUX_KERNEL_DTS_SUPPORT=y
        BR2_LINUX_KERNEL_INTREE_DTS_NAME="versatile-pb"
        BR2_PACKAGE_BUSYBOX_SHOW_OTHERS=y
        BR2_PACKAGE_SYSLOG_NG=y
        BR2_TARGET_ROOTFS_CPIO=y
        # BR2_TARGET_ROOTFS_TAR is not set
        """.format(infra.filepath("conf/syslog-ng-kernel-fragment.config"))

    def test_run(self):
        kernel = os.path.join(self.builddir, "images", "zImage")
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        dtb = os.path.join(self.builddir, "images", "versatile-pb.dtb")
        options = ["-M", "versatilepb",
                   "-dtb", dtb,
                   "-initrd", cpio_file,
                   "-device", "virtio-rng-pci"]
        self.emulator.boot(arch="armv5", kernel=kernel, options=options)
        self.emulator.login()

        cmd = "grep syslog-ng /var/log/messages | grep starting"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        cmd = "logger my-message;"
        cmd += "sleep 1;"
        cmd += "grep my-message /var/log/messages"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        cmd = "syslog-ng-ctl reload;"
        cmd += "sleep 1;"
        cmd += "grep syslog-ng /var/log/messages | grep -i warning"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 1)
