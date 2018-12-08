import os

import infra.basetest


class TestPythonBase(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_TARGET_ROOTFS_CPIO=y
        # BR2_TARGET_ROOTFS_TAR is not set
        """
    interpreter = "python"

    def login(self):
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv5",
                           kernel="builtin",
                           options=["-initrd", cpio_file])
        self.emulator.login()

    def version_test(self, version, timeout=-1):
        cmd = self.interpreter + " --version 2>&1 | grep '^{}'".format(version)
        _, exit_code = self.emulator.run(cmd, timeout)
        self.assertEqual(exit_code, 0)

    def math_floor_test(self, timeout=-1):
        cmd = self.interpreter + " -c 'import math; math.floor(12.3)'"
        _, exit_code = self.emulator.run(cmd, timeout)
        self.assertEqual(exit_code, 0)

    def libc_time_test(self, timeout=-1):
        cmd = self.interpreter + " -c 'from __future__ import print_function;"
        cmd += "import ctypes;"
        cmd += "libc = ctypes.cdll.LoadLibrary(\"libc.so.1\");"
        cmd += "print(libc.time(None))'"
        _, exit_code = self.emulator.run(cmd, timeout)
        self.assertEqual(exit_code, 0)

    def zlib_test(self, timeout=-1):
        cmd = self.interpreter + " -c 'import zlib'"
        _, exit_code = self.emulator.run(cmd, timeout)
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


class TestPython3(TestPythonBase):
    config = TestPythonBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        """

    def test_run(self):
        self.login()
        self.version_test("Python 3")
        self.math_floor_test()
        self.libc_time_test()
        self.zlib_test()


class TestPythonPackageBase(TestPythonBase):
    """Common class to test a python package.

    Build an image containing the scripts listed in sample_scripts, start the
    emulator, login to it and for each sample script in the image run the python
    interpreter passing the name of the script and check the status code is 0.

    Each test case that inherits from this class must have:
    __test__ = True  - to let nose2 know that it is a test case
    config           - defconfig fragment with the packages to run the test
    It also can have:
    sample_scripts   - list of scripts to add to the image and run on the target
    timeout          - timeout to the script to run when the default from the
                       test infra is not enough
    When custom commands need be issued on the target the method
    run_sample_scripts can be overridden.
    """

    __test__ = False
    config_sample_scripts = \
        """
        BR2_ROOTFS_POST_BUILD_SCRIPT="{}"
        BR2_ROOTFS_POST_SCRIPT_ARGS="{}"
        """.format(infra.filepath("tests/package/copy-sample-script-to-target.sh"),
                   "{sample_scripts}")
    sample_scripts = None
    timeout = -1

    def __init__(self, names):
        """Add the scripts to the target in build time."""
        super(TestPythonPackageBase, self).__init__(names)
        if self.sample_scripts:
            scripts = [infra.filepath(s) for s in self.sample_scripts]
            self.config += self.config_sample_scripts.format(sample_scripts=" ".join(scripts))

    def check_sample_scripts_exist(self):
        """Check the scripts were really added to the image."""
        scripts = [os.path.basename(s) for s in self.sample_scripts]
        cmd = "md5sum " + " ".join(scripts)
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

    def run_sample_scripts(self):
        """Run each script previously added to the image."""
        for script in self.sample_scripts:
            cmd = self.interpreter + " " + os.path.basename(script)
            _, exit_code = self.emulator.run(cmd, timeout=self.timeout)
            self.assertEqual(exit_code, 0)

    def test_run(self):
        self.login()
        self.check_sample_scripts_exist()
        self.run_sample_scripts()
