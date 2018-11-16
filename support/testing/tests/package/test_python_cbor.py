from tests.package.test_python import TestPythonPackageBase


class TestPythonPy2Cbor(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_CBOR=y
        """
    sample_scripts = ["tests/package/sample_python_cbor_enc.py",
                      "tests/package/sample_python_cbor_dec.py"]


class TestPythonPy3Cbor(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_CBOR=y
        """
    sample_scripts = ["tests/package/sample_python_cbor_enc.py",
                      "tests/package/sample_python_cbor_dec.py"]
