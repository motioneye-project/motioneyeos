from tests.package.test_perl import TestPerlBase


class TestPerlMailDKIM(TestPerlBase):
    """
    package:
        Mail-DKIM
    direct dependencies:
        Crypt-OpenSSL-RSA
        MailTools
        Net-DNS
        Net-DNS-Resolver-Mock
        YAML-LibYAML
    indirect dependencies:
        Crypt-OpenSSL-Random
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
        self.module_test("Mail::DKIM")
