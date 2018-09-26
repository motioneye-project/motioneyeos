from tests.package.test_python import TestPythonBase


class TestPythonPy2Txaio(TestPythonBase):
    config = TestPythonBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_TXAIO=y
        BR2_PACKAGE_PYTHON_TWISTED=y
        """

    def test_run(self):
        self.login()
        cmd = self.interpreter + " -c 'import txaio;"
        cmd += "txaio.use_twisted();"
        cmd += "f0 = txaio.create_future()'"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)


class TestPythonPy3Txaio(TestPythonBase):
    config = TestPythonBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_TXAIO=y
        """

    def test_run(self):
        self.login()
        cmd = self.interpreter + " -c 'import txaio;"
        cmd += "txaio.use_asyncio();"
        cmd += "f0 = txaio.create_future()'"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)
