from tests.package.test_python import TestPythonPackageBase


class TestPythonClick(TestPythonPackageBase):
    sample_scripts = ["tests/package/sample_python_click.py"]

    def run_sample_scripts(self):
        cmd = self.interpreter + " sample_python_click.py --help"
        output, exit_code = self.emulator.run(cmd)
        self.assertIn("Usage:", output[0])
        self.assertEqual(exit_code, 0)

        cmd = self.interpreter + " sample_python_click.py 123"
        output, exit_code = self.emulator.run(cmd)
        self.assertEqual(output[0], "123, False")
        self.assertEqual(exit_code, 0)

        cmd = self.interpreter + " sample_python_click.py --bar 456"
        output, exit_code = self.emulator.run(cmd)
        self.assertEqual(output[0], "456, True")
        self.assertEqual(exit_code, 0)

        cmd = self.interpreter + " sample_python_click.py"
        output, exit_code = self.emulator.run(cmd)
        self.assertIn("Usage:", output[0])
        self.assertEqual(exit_code, 2)


class TestPythonPy2Click(TestPythonClick):
    __test__ = True
    config = TestPythonClick.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_CLICK=y
        """


class TestPythonPy3Click(TestPythonClick):
    __test__ = True
    config = TestPythonClick.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_CLICK=y
        """
