from tests.package.test_lua import TestLuaBase


class TestLuaUtf8(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LUA_UTF8=y
        """

    def test_run(self):
        self.login()
        self.module_test("utf8")


class TestLuajitUtf8(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LUA_UTF8=y
        """

    def test_run(self):
        self.login()
        self.module_test("utf8")
