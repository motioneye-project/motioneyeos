from tests.package.test_python import TestPythonBase

TEST_SCRIPT = """
from twisted.internet import protocol, reactor, endpoints
class F(protocol.Factory):
    pass
endpoints.serverFromString(reactor, "tcp:1234").listen(F())
reactor.run()
"""


class TestPythonTwisted(TestPythonBase):
    def import_test(self):
        cmd = "printf '{}' > test.py".format(TEST_SCRIPT)
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        cmd = "netstat -ltn 2>/dev/null | grep 0.0.0.0:1234"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 1)

        cmd = self.interpreter + " test.py &"
        # give some time to setup the server
        cmd += "sleep 30"
        _, exit_code = self.emulator.run(cmd, timeout=35)
        self.assertEqual(exit_code, 0)

        cmd = "netstat -ltn 2>/dev/null | grep 0.0.0.0:1234"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)


class TestPythonPy2Twisted(TestPythonTwisted):
    config = TestPythonBase.config + \
        """
        BR2_PACKAGE_PYTHON=y
        BR2_PACKAGE_PYTHON_TWISTED=y
        """

    def test_run(self):
        self.login()
        self.import_test()


class TestPythonPy3Twisted(TestPythonTwisted):
    config = TestPythonBase.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_TWISTED=y
        """

    def test_run(self):
        self.login()
        self.import_test()
