from tests.package.test_python import TestPythonPackageBase


class TestPythonTwisted(TestPythonPackageBase):
    config = TestPythonPackageBase.config
    sample_scripts = ["tests/package/sample_python_twisted.py"]

    def run_sample_scripts(self):
        cmd = "netstat -ltn 2>/dev/null | grep 0.0.0.0:1234"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 1)

        cmd = self.interpreter + " sample_python_twisted.py &"
        # give some time to setup the server
        cmd += "sleep 30"
        _, exit_code = self.emulator.run(cmd, timeout=35)
        self.assertEqual(exit_code, 0)

        cmd = "netstat -ltn 2>/dev/null | grep 0.0.0.0:1234"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)


class TestPythonPy2Twisted(TestPythonTwisted):
    __test__ = True
    config = TestPythonTwisted.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_TWISTED=y
        """


class TestPythonPy3Twisted(TestPythonTwisted):
    __test__ = True
    config = TestPythonTwisted.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_TWISTED=y
        """
