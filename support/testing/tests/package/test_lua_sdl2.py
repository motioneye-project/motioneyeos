from tests.package.test_lua import TestLuaBase


class TestLuaLuaSDL2(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LUA_SDL2=y
        BR2_PACKAGE_SDL2_IMAGE=y
        BR2_PACKAGE_SDL2_MIXER=y
        BR2_PACKAGE_SDL2_NET=y
        BR2_PACKAGE_SDL2_TTF=y
        """

    def test_run(self):
        self.login()
        self.module_test("SDL")
        self.module_test("SDL.image")
        self.module_test("SDL.mixer")
        self.module_test("SDL.net")
        self.module_test("SDL.ttf")


class TestLuajitLuaSDL2(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LUA_SDL2=y
        BR2_PACKAGE_SDL2_IMAGE=y
        BR2_PACKAGE_SDL2_MIXER=y
        BR2_PACKAGE_SDL2_NET=y
        BR2_PACKAGE_SDL2_TTF=y
        """

    def test_run(self):
        self.login()
        self.module_test("SDL")
        self.module_test("SDL.image")
        self.module_test("SDL.mixer")
        self.module_test("SDL.net")
        self.module_test("SDL.ttf")
