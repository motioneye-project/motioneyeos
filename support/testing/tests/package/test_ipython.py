import os

from tests.package.test_python import TestPythonBase
#
# The following pythong tests are not being used here:
#
# - version_test: IPython does not support --version option
#
# - zlib_test: IPython does not return a non-zero code the way CPython
#              does, so this test ends up being a false-negative
#
class TestIPythonPy2(TestPythonBase):
    config = TestPythonBase.config + \
"""
BR2_PACKAGE_PYTHON=y
BR2_PACKAGE_PYTHON_IPYTHON=y
"""
    interpreter = "ipython"

    def test_run(self):
        self.login()
        self.math_floor_test(40)
        self.libc_time_test(40)

class TestIPythonPy3(TestPythonBase):
    config = TestPythonBase.config + \
"""
BR2_PACKAGE_PYTHON3=y
BR2_PACKAGE_PYTHON_IPYTHON=y
"""
    interpreter = "ipython"

    def test_run(self):
        self.login()
        self.math_floor_test(40)
        self.libc_time_test(40)


