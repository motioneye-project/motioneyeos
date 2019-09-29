from tests.package.test_perl import TestPerlBase


class TestPerllibwwwperl(TestPerlBase):
    """
    package:
        libwww-perl
    direct dependencies:
        Encode-Locale
        File-Listing
        HTML-Parser   XS
        HTTP-Cookies
        HTTP-Daemon
        HTTP-Date
        HTTP-Message
        HTTP-Negotiate
        LWP-MediaTypes
        Net-HTTP
        Try-Tiny
        URI
        WWW-RobotRules
    indirect dependencies:
        HTML-Tagset
        IO-HTML
    """

    config = TestPerlBase.config + \
        """
        BR2_PACKAGE_PERL=y
        BR2_PACKAGE_PERL_LIBWWW_PERL=y
        """

    def test_run(self):
        self.login()
        self.module_test("LWP")
        self.module_test("LWP::UserAgent")
        self.module_test("LWP::Authen::Basic")
        self.module_test("LWP::Authen::Digest")
        self.module_test("HTTP::Message")
        self.module_test("HTTP::Daemon")
        self.module_test("WWW::RobotRules")
