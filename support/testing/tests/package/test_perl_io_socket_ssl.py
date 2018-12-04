from tests.package.test_perl import TestPerlBase


class TestPerlIOSocketSSL(TestPerlBase):
    """
    package:
        IO-Socket-SSL
    direct dependencies:
        Net-SSLeay   XS
    """

    config = TestPerlBase.config + \
        """
        BR2_PACKAGE_PERL=y
        BR2_PACKAGE_PERL_IO_SOCKET_SSL=y
        """

    def test_run(self):
        self.login()
        self.module_test("Net::SSLeay")
        self.module_test("IO::Socket::SSL")
