from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2Constantly(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_CONSTANTLY=y
        """
    sample_scripts = ["tests/package/sample_python_constantly.py"]


class TestPythonPy3Constantly(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_CONSTANTLY=y
        """
    sample_scripts = ["tests/package/sample_python_constantly.py"]
