from tests.package.test_lua import TestLuaBase


class TestLuaLuaSocket(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LUASOCKET=y
        """

    def test_run(self):
        self.login()
        self.module_test("ltn12")
        self.module_test("mime")
        self.module_test("socket")


class TestLuajitLuaSocket(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LUASOCKET=y
        """

    def test_run(self):
        self.login()
        self.module_test("ltn12")
        self.module_test("mime")
        self.module_test("socket")
