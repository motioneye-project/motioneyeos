from tests.package.test_perl import TestPerlBase


class TestPerlDBDmysql(TestPerlBase):
    """
    package:
        DBD-mysql   XS
    direct dependencies:
        DBI   XS
    """

    config = TestPerlBase.config + \
        """
        BR2_PACKAGE_PERL=y
        BR2_PACKAGE_PERL_DBD_MYSQL=y
        """

    def test_run(self):
        self.login()
        self.module_test("DBI")
        self.module_test("DBD::mysql")
