import os
from tests.package.test_python import TestPythonPackageBase


INI_FILE_CONTENT = """
[section]
param = this-is-the-magic-value
other = dont care
"""


class TestCrudiniBase(TestPythonPackageBase):
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_CRUDINI=y
        """

    def test_run(self):
        img = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv5", kernel="builtin",
                           options=["-initrd", img])

        self.emulator.login()

        # 1. Create some sample .ini file
        cmd = "echo -e '%s' > config.ini" % INI_FILE_CONTENT
        _, ret = self.emulator.run(cmd)
        self.assertEqual(ret, 0)

        # 2. Attempt to get the value
        out, ret = self.emulator.run("crudini --get config.ini section param")
        self.assertEqual(ret, 0)
        self.assertEqual(out, ['this-is-the-magic-value'])


class TestCrudiniPy2(TestCrudiniBase):
    __test__ = True
    config = TestCrudiniBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        """


class TestCrudiniPy3(TestCrudiniBase):
    __test__ = True
    config = TestCrudiniBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        """
