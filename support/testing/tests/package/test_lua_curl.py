from tests.package.test_lua import TestLuaBase


class TestLuaLuacURL(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LUA_CURL=y
        """

    def test_run(self):
        self.login()
        self.module_test("cURL")
        self.module_test("lcurl")


class TestLuajitLuacURL(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LUA_CURL=y
        """

    def test_run(self):
        self.login()
        self.module_test("cURL")
        self.module_test("lcurl")
