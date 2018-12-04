from tests.package.test_perl import TestPerlBase


class TestPerlEncodeDetect(TestPerlBase):
    """
    package:
        Encode-Detect   XS
    direct dependencies:
        Module-Build
    """

    config = TestPerlBase.config + \
        """
        BR2_PACKAGE_PERL=y
        BR2_PACKAGE_PERL_ENCODE_DETECT=y
        """

    def test_run(self):
        self.login()
        self.module_test("Encode::Detect")
