from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2Passlib(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_PASSLIB=y
        """
    sample_scripts = ["tests/package/sample_python_passlib.py"]
    timeout = 30


class TestPythonPy3Passlib(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_PASSLIB=y
        """
    sample_scripts = ["tests/package/sample_python_passlib.py"]
    timeout = 30
