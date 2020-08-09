from tests.package.test_lua import TestLuaBase


class TestLuaLuaLyaml(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LUA_LYAML=y
        """

    def test_run(self):
        self.login()
        self.module_test("yaml")
        self.module_test("lyaml")


class TestLuajitLuaLyaml(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LUA_LYAML=y
        """

    def test_run(self):
        self.login()
        self.module_test("yaml")
        self.module_test("lyaml")
