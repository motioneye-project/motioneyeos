from tests.package.test_lua import TestLuaBase


class TestLuaLuaExpat(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LUAEXPAT=y
        """

    def test_run(self):
        self.login()
        self.module_test("lxp")


class TestLuajitLuaExpat(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LUAEXPAT=y
        """

    def test_run(self):
        self.login()
        self.module_test("lxp")
