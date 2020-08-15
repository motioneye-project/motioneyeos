from tests.package.test_lua import TestLuaBase


class TestLuaLuaGD(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LUA_GD=y
        BR2_PACKAGE_FONTCONFIG=y
        BR2_PACKAGE_JPEG=y
        BR2_PACKAGE_LIBPNG=y
        """

    def test_run(self):
        self.login()
        self.module_test("gd")


class TestLuajitLuaGD(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LUA_GD=y
        BR2_PACKAGE_FONTCONFIG=y
        BR2_PACKAGE_JPEG=y
        BR2_PACKAGE_LIBPNG=y
        """

    def test_run(self):
        self.login()
        self.module_test("gd")
