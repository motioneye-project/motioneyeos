import os

import infra.basetest

class TestPythonBase(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
"""
BR2_TARGET_ROOTFS_CPIO=y
# BR2_TARGET_ROOTFS_TAR is not set
"""
    def login(self):
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv5",
                           kernel="builtin",
                           options=["-initrd", cpio_file])
        self.emulator.login()

    def version_test(self, version):
        cmd = "python --version 2>&1 | grep '^{}'".format(version)
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

    def math_floor_test(self):
        cmd = "python -c 'import math; math.floor(12.3)'"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

    def libc_time_test(self):
        cmd = "python -c 'import ctypes;"
        cmd += "libc = ctypes.cdll.LoadLibrary(\"libc.so.1\");"
        cmd += "print libc.time(None)'"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

    def zlib_test(self):
        cmd = "python -c 'import zlib'"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 1)

class TestPython2(TestPythonBase):
    config = TestPythonBase.config + \
"""
BR2_PACKAGE_PYTHON=y
"""
    def test_run(self):
        self.login()
        self.version_test("Python 2")
        self.math_floor_test()
        self.libc_time_test()
        self.zlib_test()
