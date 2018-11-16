from tests.package.test_python import TestPythonPackageBase


class TestPythonArgh(TestPythonPackageBase):
    config = TestPythonPackageBase.config
    sample_scripts = ["tests/package/sample_python_argh.py"]

    def run_sample_scripts(self):
        cmd = self.interpreter + " sample_python_argh.py -h"
        output, exit_code = self.emulator.run(cmd)
        self.assertIn("usage:", output[0])
        self.assertEqual(exit_code, 0)

        cmd = self.interpreter + " sample_python_argh.py 123"
        output, exit_code = self.emulator.run(cmd)
        self.assertEqual(output[0], "123, False")
        self.assertEqual(exit_code, 0)

        cmd = self.interpreter + " sample_python_argh.py --bar 456"
        output, exit_code = self.emulator.run(cmd)
        self.assertEqual(output[0], "456, True")
        self.assertEqual(exit_code, 0)

        cmd = self.interpreter + " sample_python_argh.py"
        output, exit_code = self.emulator.run(cmd)
        self.assertIn("usage:", output[0])
        self.assertEqual(exit_code, 2)


class TestPythonPy2Argh(TestPythonArgh):
    __test__ = True
    config = TestPythonArgh.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_ARGH=y
        """


class TestPythonPy3Argh(TestPythonArgh):
    __test__ = True
    config = TestPythonArgh.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_ARGH=y
        """
