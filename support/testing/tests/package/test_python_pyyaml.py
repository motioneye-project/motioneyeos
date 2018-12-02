from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2Pyyaml(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_PYYAML=y
        """
    sample_scripts = ["tests/package/sample_python_pyyaml_enc.py",
                      "tests/package/sample_python_pyyaml_dec.py"]


class TestPythonPy3Pyyaml(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_PYYAML=y
        """
    sample_scripts = ["tests/package/sample_python_pyyaml_enc.py",
                      "tests/package/sample_python_pyyaml_dec.py"]
