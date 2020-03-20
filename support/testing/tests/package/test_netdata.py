import os

import infra.basetest


class TestNetdata(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_PACKAGE_NETDATA=y
        BR2_TARGET_ROOTFS_CPIO=y
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def test_run(self):
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv5",
                           kernel="builtin",
                           options=["-initrd", cpio_file])
        self.emulator.login()

        cmd = "wget localhost:19999 -O - | grep '<title>netdata dashboard</title>'"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)
