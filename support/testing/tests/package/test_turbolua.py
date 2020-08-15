from tests.package.test_lua import TestLuaBase


class TestLuajitTurbolua(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_TURBOLUA=y
        """

    def test_run(self):
        self.login()
        self.module_test("turbo")
