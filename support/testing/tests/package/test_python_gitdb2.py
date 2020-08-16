from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2Gitdb2(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_GITDB2=y
        """
    sample_scripts = ["tests/package/sample_python_gitdb2.py"]


class TestPythonPy3Gitdb2(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_GITDB2=y
        """
    sample_scripts = ["tests/package/sample_python_gitdb2.py"]
