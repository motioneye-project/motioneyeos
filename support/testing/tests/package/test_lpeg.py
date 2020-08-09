from tests.package.test_lua import TestLuaBase


class TestLuaLPeg(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LPEG=y
        """

    def test_run(self):
        self.login()
        self.module_test("lpeg")
        self.module_test("re")


class TestLuajitLPeg(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LPEG=y
        """

    def test_run(self):
        self.login()
        self.module_test("lpeg")
        self.module_test("re")
