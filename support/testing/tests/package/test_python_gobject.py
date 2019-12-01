from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2Gobject(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_GOBJECT=y
        """
    sample_scripts = ["tests/package/sample_python_gobject.py"]
