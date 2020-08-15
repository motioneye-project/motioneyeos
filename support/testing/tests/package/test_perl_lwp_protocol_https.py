from tests.package.test_perl import TestPerlBase


class TestPerlLWPProtocolhttps(TestPerlBase):
    """
    package:
        LWP-Protocol-https
    direct dependencies:
        IO-Socket-SSL
        Mozilla-CA
        Net-HTTP
        libwww-perl
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
        LWP-MediaTypes
        Net-SSLeay   XS
        TimeDate
        Try-Tiny
        URI
        WWW-RobotRules
    """

    config = TestPerlBase.config + \
        """
        BR2_PACKAGE_PERL=y
        BR2_PACKAGE_PERL_LWP_PROTOCOL_HTTPS=y
        """

    def test_run(self):
        self.login()
        self.module_test("HTML::Parser")
        self.module_test("Net::SSLeay")
        self.module_test("LWP::Protocol::https")
