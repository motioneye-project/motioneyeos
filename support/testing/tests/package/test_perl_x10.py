from tests.package.test_perl import TestPerlBase


class TestPerlX10(TestPerlBase):
    """
    package:
        X10
    direct dependencies:
        Astro-SunTime
        Device-SerialPort   XS
        Time-ParseDate
    """

    config = TestPerlBase.config + \
        """
        BR2_PACKAGE_PERL=y
        BR2_PACKAGE_PERL_X10=y
        """

    def test_run(self):
        self.login()
        self.module_test("X10")
