import os

import infra.basetest


def dumpf2fs_getprop(out, prop):
    for line in out:
        fields = line.split(" = ")
        if fields[0] == prop:
            return fields[1].strip()


class TestF2FS(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_TARGET_ROOTFS_F2FS=y
        BR2_TARGET_ROOTFS_F2FS_SIZE="128M"
        BR2_TARGET_ROOTFS_F2FS_OVERPROVISION=0
        BR2_TARGET_ROOTFS_F2FS_DISCARD=y
        # BR2_TARGET_ROOTFS_TAR is not set
        BR2_LINUX_KERNEL=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="4.16.7"
        BR2_LINUX_KERNEL_USE_DEFCONFIG=y
        BR2_LINUX_KERNEL_DEFCONFIG="vexpress"
        BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES="{}"
        """.format(infra.filepath("conf/f2fs-kernel-fragment.config"))

    def test_run(self):
        img = os.path.join(self.builddir, "images", "rootfs.f2fs")
        out = infra.run_cmd_on_host(self.builddir, ["host/sbin/dump.f2fs", img])
        out = out.splitlines()
        prop = dumpf2fs_getprop(out, "Info: total sectors")
        self.assertEqual(prop, "262144 (128 MB)")

        kernel = os.path.join(self.builddir, "images", "zImage")
        kernel_cmdline = ["root=/dev/mmcblk0", "rootfstype=f2fs",
                          "console=ttyAMA0"]
        dtb = infra.download(self.downloaddir, "vexpress-v2p-ca9.dtb")
        options = ["-M", "vexpress-a9", "-dtb", dtb,
                   "-drive", "file={},if=sd,format=raw".format(img)]
        self.emulator.boot(arch="armv7", kernel=kernel,
                           kernel_cmdline=kernel_cmdline,
                           options=options)
        self.emulator.login()
        cmd = "mount | grep '/dev/root on / type f2fs'"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)
