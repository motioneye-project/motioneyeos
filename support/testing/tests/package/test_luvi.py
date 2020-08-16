import os

import infra.basetest


class TestLuvi(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_TARGET_ROOTFS_CPIO=y
        # BR2_TARGET_ROOTFS_TAR is not set
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LUVI=y
        BR2_PACKAGE_OPENSSL=y
        BR2_PACKAGE_PCRE=y
        BR2_PACKAGE_ZLIB=y
        """

    def login(self):
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv7",
                           kernel="builtin",
                           options=["-initrd", cpio_file])
        self.emulator.login()

    def version_test(self):
        cmd = "luvi -v"
        output, exit_code = self.emulator.run(cmd)
        self.assertIn('luvi', output[0])
        self.assertIn('zlib', output[1])
        self.assertIn('rex', output[2])
        self.assertIn('libuv', output[3])
        self.assertIn('ssl', output[4])

    def test_run(self):
        self.login()
        self.version_test()
