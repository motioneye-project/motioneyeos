from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2ServiceIdentity(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_SERVICE_IDENTITY=y
        """
    sample_scripts = ["tests/package/sample_python_service_identity.py"]
    timeout = 30


class TestPythonPy3ServiceIdentity(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_SERVICE_IDENTITY=y
        """
    sample_scripts = ["tests/package/sample_python_service_identity.py"]
    timeout = 30
