from tests.package.test_python import TestPythonBase


class TestPythonIncremental(TestPythonBase):
    def str_test(self):
        cmd = self.interpreter + " -c 'import incremental;"
        cmd += "v = incremental.Version(\"package\", 1, 2, 3, release_candidate=4);"
        cmd += "assert(str(v) == \"[package, version 1.2.3rc4]\")'"
        _, exit_code = self.emulator.run(cmd, timeout=30)
        self.assertEqual(exit_code, 0)


class TestPythonPy2Incremental(TestPythonIncremental):
    config = TestPythonBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_INCREMENTAL=y
        """

    def test_run(self):
        self.login()
        self.str_test()


class TestPythonPy3Incremental(TestPythonIncremental):
    config = TestPythonBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_INCREMENTAL=y
        """

    def test_run(self):
        self.login()
        self.str_test()
