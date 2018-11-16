from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2Bitstring(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_BITSTRING=y
        """
    sample_scripts = ["tests/package/sample_python_bitstring.py"]


class TestPythonPy3Bitstring(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_BITSTRING=y
        """
    sample_scripts = ["tests/package/sample_python_bitstring.py"]
