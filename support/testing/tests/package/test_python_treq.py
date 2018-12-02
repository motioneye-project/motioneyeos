from tests.package.test_python import TestPythonPackageBase


class TestPythonTreq(TestPythonPackageBase):
    sample_scripts = ["tests/package/sample_python_treq.py"]

    def run_sample_scripts(self):
        cmd = self.interpreter + " sample_python_treq.py"
        output, exit_code = self.emulator.run(cmd, timeout=20)
        self.assertIn("Connection refused", output[0])
        self.assertEqual(exit_code, 0)


class TestPythonPy2Treq(TestPythonTreq):
    __test__ = True
    config = TestPythonTreq.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_TREQ=y
        """


class TestPythonPy3Treq(TestPythonTreq):
    __test__ = True
    config = TestPythonTreq.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_TREQ=y
        """
