from tests.package.test_python import TestPythonBase


class TestPythonAutobahn(TestPythonBase):
    def import_test(self):
        cmd = self.interpreter + " -c 'import autobahn.wamp'"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)


class TestPythonPy2Autobahn(TestPythonAutobahn):
    config = TestPythonBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_AUTOBAHN=y
        """

    def test_run(self):
        self.login()
        self.import_test()


class TestPythonPy3Autobahn(TestPythonAutobahn):
    config = TestPythonBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_AUTOBAHN=y
        """

    def test_run(self):
        self.login()
        self.import_test()
