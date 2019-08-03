import os

import infra.basetest

BASIC_TOOLCHAIN_CONFIG_HEADERS_AT_LEAST_3_14 = \
    """
    BR2_arm=y
    BR2_TOOLCHAIN_EXTERNAL=y
    BR2_TOOLCHAIN_EXTERNAL_CUSTOM=y
    BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD=y
    BR2_TOOLCHAIN_EXTERNAL_URL="http://autobuild.buildroot.org/toolchains/tarballs/br-arm-full-2019.05.1.tar.bz2"
    BR2_TOOLCHAIN_EXTERNAL_GCC_4_9=y
    BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_14=y
    BR2_TOOLCHAIN_EXTERNAL_LOCALE=y
    # BR2_TOOLCHAIN_EXTERNAL_HAS_THREADS_DEBUG is not set
    BR2_TOOLCHAIN_EXTERNAL_CXX=y
    """


class TestAtop(infra.basetest.BRTest):
    config = BASIC_TOOLCHAIN_CONFIG_HEADERS_AT_LEAST_3_14 + \
        """
        BR2_PACKAGE_ATOP=y
        BR2_TARGET_ROOTFS_CPIO=y
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def test_run(self):
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv5",
                           kernel="builtin",
                           options=["-initrd", cpio_file])
        self.emulator.login()

        cmd = "atop -V | grep '^Version'"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        cmd = "atop -a 1 2 | grep '% *atop *$'"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)
