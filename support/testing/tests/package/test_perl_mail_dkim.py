from tests.package.test_perl import TestPerlBase


class TestPerlMailDKIM(TestPerlBase):
    """
    package:
        Mail-DKIM
    direct dependencies:
        Crypt-OpenSSL-RSA   XS
        MailTools
        Net-DNS
        Net-DNS-Resolver-Mock
        YAML-LibYAML   XS
    indirect dependencies:
        Crypt-OpenSSL-Random   XS
        Digest-HMAC
        TimeDate
    """

    config = TestPerlBase.config + \
        """
        BR2_PACKAGE_PERL=y
        BR2_PACKAGE_PERL_MAIL_DKIM=y
        """

    def test_run(self):
        self.login()
        self.module_test("Crypt::OpenSSL::Random")
        self.module_test("Crypt::OpenSSL::RSA")
        self.module_test("Mail::DKIM")
