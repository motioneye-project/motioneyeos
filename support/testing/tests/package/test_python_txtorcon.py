from tests.package.test_python import TestPythonBase


class TestPythonTxtorcon(TestPythonBase):
    def import_test(self):
        cmd = self.interpreter + " -c 'import txtorcon'"
        _, exit_code = self.emulator.run(cmd, timeout=30)
        self.assertEqual(exit_code, 0)


class TestPythonPy2Txtorcon(TestPythonTxtorcon):
    config = TestPythonBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_TXTORCON=y
        """

    def test_run(self):
        self.login()
        self.import_test()


class TestPythonPy3Txtorcon(TestPythonTxtorcon):
    config = TestPythonBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_TXTORCON=y
        """

    def test_run(self):
        self.login()
        self.import_test()
