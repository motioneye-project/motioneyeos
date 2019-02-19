from tests.package.test_lua import TestLuaBase


class TestLuaLsqlite3(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LSQLITE3=y
        """

    def test_run(self):
        self.login()
        self.module_test("lsqlite3")


class TestLuajitLsqlite3(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LSQLITE3=y
        """

    def test_run(self):
        self.login()
        self.module_test("lsqlite3")
