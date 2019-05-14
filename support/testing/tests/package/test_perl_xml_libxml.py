from tests.package.test_perl import TestPerlBase


class TestPerlXMLLibXML(TestPerlBase):
    """
    package:
        XML-LibXML   XS
    direct dependencies:
        XML-NamespaceSupport
        XML-SAX
        XML-SAX-Base
    """

    config = TestPerlBase.config + \
        """
        BR2_PACKAGE_PERL=y
        BR2_PACKAGE_PERL_XML_LIBXML=y
        """

    def test_run(self):
        self.login()
        self.module_test("XML::LibXML")
