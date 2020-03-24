import os
from tests.package.test_python import TestPythonPackageBase


class TestPythonPy3Gobject(TestPythonPackageBase):
    __test__ = True
    config = \
        """
        BR2_arm=y
        BR2_ARM_ENABLE_VFP=y
        BR2_cortex_a9=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_PACKAGE_GOBJECT_INTROSPECTION=y
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_GOBJECT=y
        BR2_TARGET_ROOTFS_CPIO=y
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def login(self):
        img = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv7",
                           kernel="builtin",
                           options=["-initrd", img])
        self.emulator.login()

    sample_scripts = ["tests/package/sample_python_gobject.py"]
