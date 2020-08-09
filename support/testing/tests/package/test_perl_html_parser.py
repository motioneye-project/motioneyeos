from tests.package.test_perl import TestPerlBase


class TestPerlHTMLParser(TestPerlBase):
    """
    package:
        HTML-Parser   XS
    direct dependencies:
        HTML-Tagset
    """

    config = TestPerlBase.config + \
        """
        BR2_PACKAGE_PERL=y
        BR2_PACKAGE_PERL_HTML_PARSER=y
        """

    def test_run(self):
        self.login()
        self.module_test("HTML::Parser")
