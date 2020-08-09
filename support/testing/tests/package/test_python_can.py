from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2Can(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_CAN=y
        """
    sample_scripts = ["tests/package/sample_python_can.py"]
    timeout = 40


class TestPythonPy3Can(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_CAN=y
        """
    sample_scripts = ["tests/package/sample_python_can.py"]
    timeout = 40
