import os

import infra.basetest


class TestLuaBase(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_TARGET_ROOTFS_CPIO=y
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def login(self):
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv7",
                           kernel="builtin",
                           options=["-initrd", cpio_file])
        self.emulator.login()

    def version_test(self, version):
        cmd = "lua -v"
        output, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)
        self.assertIn(version, output[0])

    def g_version_test(self, expected):
        cmd = "lua -e 'print(_G._VERSION)'"
        output, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)
        self.assertEqual(output[0], expected)

    def module_test(self, module, script="a=1"):
        cmd = "lua -l {} -e '{}'".format(module, script)
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)


class TestLua(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        """

    def test_run(self):
        self.login()
        self.version_test('Lua 5.3')
        self.g_version_test('Lua 5.3')


class TestLuajit(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        """

    def test_run(self):
        self.login()
        self.version_test('LuaJIT 2')
        self.g_version_test('Lua 5.1')
