from tests.package.test_python import TestPythonBase


class TestPythonCryptography(TestPythonBase):
    def fernet_test(self, timeout=-1):
        cmd = self.interpreter + " -c 'from cryptography.fernet import Fernet;"
        cmd += "key = Fernet.generate_key();"
        cmd += "f = Fernet(key)'"
        _, exit_code = self.emulator.run(cmd, timeout)
        self.assertEqual(exit_code, 0)


class TestPythonPy2Cryptography(TestPythonCryptography):
    config = TestPythonBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_CRYPTOGRAPHY=y
        """

    def test_run(self):
        self.login()
        self.fernet_test(40)


class TestPythonPy3Cryptography(TestPythonCryptography):
    config = TestPythonBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_CRYPTOGRAPHY=y
        """

    def test_run(self):
        self.login()
        self.fernet_test(40)
