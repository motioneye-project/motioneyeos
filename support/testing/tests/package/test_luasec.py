from tests.package.test_lua import TestLuaBase


class TestLuaLuaSec(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LUASEC=y
        """

    def test_run(self):
        self.login()
        self.module_test("ssl")


class TestLuajitLuaSec(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LUASEC=y
        """

    def test_run(self):
        self.login()
        self.module_test("ssl")
