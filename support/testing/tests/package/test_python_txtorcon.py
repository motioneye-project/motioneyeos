from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2Txtorcon(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_TXTORCON=y
        """
    sample_scripts = ["tests/package/sample_python_txtorcon.py"]
    timeout = 30


class TestPythonPy3Txtorcon(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_TXTORCON=y
        """
    sample_scripts = ["tests/package/sample_python_txtorcon.py"]
    timeout = 30
