from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2Incremental(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_INCREMENTAL=y
        """
    sample_scripts = ["tests/package/sample_python_incremental.py"]
    timeout = 30


class TestPythonPy3Incremental(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_INCREMENTAL=y
        """
    sample_scripts = ["tests/package/sample_python_incremental.py"]
    timeout = 30
