from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2Pynacl(TestPythonPackageBase):
    __test__ = True
    # use haveged to generate enough entropy so pynacl -> libsodium don't hang waiting for /dev/random
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_PYNACL=y
        BR2_PACKAGE_HAVEGED=y
        """
    sample_scripts = ["tests/package/sample_python_pynacl.py"]
    timeout = 10


class TestPythonPy3Pynacl(TestPythonPackageBase):
    __test__ = True
    # use haveged to generate enough entropy so pynacl -> libsodium don't hang waiting for /dev/random
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_PYNACL=y
        BR2_PACKAGE_HAVEGED=y
        """
    sample_scripts = ["tests/package/sample_python_pynacl.py"]
    timeout = 10
