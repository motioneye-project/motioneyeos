from tests.package.test_perl import TestPerlBase


class TestPerlIOSocketMulticast(TestPerlBase):
    """
    package:
        IO-Socket-Multicast   XS
    direct dependencies:
        IO-Interface   XS
    """

    config = TestPerlBase.config + \
        """
        BR2_PACKAGE_PERL=y
        BR2_PACKAGE_PERL_IO_SOCKET_MULTICAST=y
        """

    def test_run(self):
        self.login()
        self.module_test("IO::Interface")
        self.module_test("IO::Socket::Multicast")
