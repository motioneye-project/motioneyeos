from tests.package.test_python import TestPythonPackageBase


class TestPythonPy3Crossbar(TestPythonPackageBase):
    __test__ = True
    # use haveged to generate enough entropy so crossbar -> pynacl -> libsodium don't hang waiting for /dev/random
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_CROSSBAR=y
        BR2_PACKAGE_HAVEGED=y
        """
    sample_scripts = ["tests/package/sample_python_crossbar.py"]
    timeout = 60
