from tests.package.test_lua import TestLuaBase


class TestProsody(TestLuaBase):
    def lua_dependencies_test(self):
        self.module_test('bit')     # luabitop
        self.module_test('lfs')     # luafilesystem
        self.module_test('lxp')     # luaexpat
        self.module_test('socket')  # luasocket
        self.module_test('ssl')     # luasec

    def prosody_test(self):
        # prosody was launched as service
        cmd = "prosodyctl status"
        output, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)
        self.assertIn("Prosody is running", output[0])


class TestProsodyLua51(TestProsody):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LUA_5_1=y
        BR2_PACKAGE_PROSODY=y
        """

    def test_run(self):
        self.login()
        self.version_test('Lua 5.1')
        self.g_version_test('Lua 5.1')
        self.lua_dependencies_test()
        self.prosody_test()


class TestProsodyLuajit(TestProsody):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_PROSODY=y
        """

    def test_run(self):
        self.login()
        self.version_test('LuaJIT 2')
        self.g_version_test('Lua 5.1')
        self.lua_dependencies_test()
        self.prosody_test()
