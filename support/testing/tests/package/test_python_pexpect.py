from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2Pexpect(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_PEXPECT=y
        """
    sample_scripts = ["tests/package/sample_python_pexpect.py"]


class TestPythonPy3Pexpect(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_PEXPECT=y
        """
    sample_scripts = ["tests/package/sample_python_pexpect.py"]
