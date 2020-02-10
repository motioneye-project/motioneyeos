from tests.package.test_perl import TestPerlBase


class TestPerlCryptSSLeay(TestPerlBase):
    """
    package:
        Crypt-SSLeay   XS
    direct dependencies:
        LWP-Protocol-https
    indirect dependencies:
        Encode-Locale
        File-Listing
        HTML-Parser   XS
        HTML-Tagset
        HTTP-Cookies
        HTTP-Daemon
        HTTP-Date
        HTTP-Message
        HTTP-Negotiate
        IO-HTML
        IO-Socket-SSL
        LWP-MediaTypes
        Mozilla-CA
        Net-HTTP
        Net-SSLeay   XS
        TimeDate
        Try-Tiny
        URI
        WWW-RobotRules
        libwww-perl
    """

    config = TestPerlBase.config + \
        """
        BR2_PACKAGE_PERL=y
        BR2_PACKAGE_PERL_CRYPT_SSLEAY=y
        """

    def test_run(self):
        self.login()
        self.module_test("HTML::Parser")
        self.module_test("Net::SSLeay")
        self.module_test("Crypt::SSLeay")
