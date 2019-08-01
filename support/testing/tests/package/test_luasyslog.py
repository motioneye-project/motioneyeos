from tests.package.test_lua import TestLuaBase


class TestLuaLuasyslog(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LUASYSLOG=y
        """

    def test_run(self):
        self.login()
        self.module_test("lsyslog")
        self.module_test("logging.syslog")


class TestLuajitLuasyslog(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LUASYSLOG=y
        """

    def test_run(self):
        self.login()
        self.module_test("lsyslog")
        self.module_test("logging.syslog")
