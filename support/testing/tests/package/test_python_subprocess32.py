from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2Subprocess32(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_SUBPROCESS32=y
        """
    sample_scripts = ["tests/package/sample_python_subprocess32.py"]
