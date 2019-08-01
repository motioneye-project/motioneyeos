from tests.package.test_lua import TestLuaBase


class TestLuaLuaPosix(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LUAPOSIX=y
        """

    def test_run(self):
        self.login()
        self.module_test("posix.version", "print(require[[posix.version]])")
        self.module_test("posix.ctype")
        self.module_test("posix.dirent")
        self.module_test("posix.errno")
        self.module_test("posix.fcntl")
        self.module_test("posix.fnmatch")
        self.module_test("posix.glob")
        self.module_test("posix.grp")
        self.module_test("posix.libgen")
        self.module_test("posix.poll")
        self.module_test("posix.pwd")
        self.module_test("posix.sched")
        self.module_test("posix.signal")
        self.module_test("posix.stdio")
        self.module_test("posix.stdlib")
        self.module_test("posix.sys.msg")
        self.module_test("posix.sys.resource")
        self.module_test("posix.sys.socket")
        self.module_test("posix.sys.stat")
        self.module_test("posix.sys.statvfs")
        self.module_test("posix.sys.time")
        self.module_test("posix.sys.times")
        self.module_test("posix.sys.utsname")
        self.module_test("posix.sys.wait")
        self.module_test("posix.syslog")
        self.module_test("posix.termio")
        self.module_test("posix.time")
        self.module_test("posix.unistd")
        self.module_test("posix.utime")
        self.module_test("posix")


class TestLuajitLuaPosix(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LUAPOSIX=y
        """

    def test_run(self):
        self.login()
        self.module_test("posix.version", "print(require[[posix.version]])")
        self.module_test("posix.ctype")
        self.module_test("posix.dirent")
        self.module_test("posix.errno")
        self.module_test("posix.fcntl")
        self.module_test("posix.fnmatch")
        self.module_test("posix.glob")
        self.module_test("posix.grp")
        self.module_test("posix.libgen")
        self.module_test("posix.poll")
        self.module_test("posix.pwd")
        self.module_test("posix.sched")
        self.module_test("posix.signal")
        self.module_test("posix.stdio")
        self.module_test("posix.stdlib")
        self.module_test("posix.sys.msg")
        self.module_test("posix.sys.resource")
        self.module_test("posix.sys.socket")
        self.module_test("posix.sys.stat")
        self.module_test("posix.sys.statvfs")
        self.module_test("posix.sys.time")
        self.module_test("posix.sys.times")
        self.module_test("posix.sys.utsname")
        self.module_test("posix.sys.wait")
        self.module_test("posix.syslog")
        self.module_test("posix.termio")
        self.module_test("posix.time")
        self.module_test("posix.unistd")
        self.module_test("posix.utime")
        self.module_test("posix")
