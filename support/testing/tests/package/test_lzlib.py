from tests.package.test_lua import TestLuaBase


class TestLuaLzlib(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LZLIB=y
        """

    def test_run(self):
        self.login()
        self.module_test("zlib")
        self.module_test("gzip")
