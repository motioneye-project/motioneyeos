from tests.package.test_lua import TestLuaBase


class TestLuaRings(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_RINGS=y
        """

    def test_run(self):
        self.login()
        self.module_test("rings")


class TestLuajitRings(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_RINGS=y
        """

    def test_run(self):
        self.login()
        self.module_test("rings")
