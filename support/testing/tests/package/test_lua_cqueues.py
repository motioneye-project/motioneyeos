from tests.package.test_lua import TestLuaBase


class TestLuaLuaCqueues(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUA=y
        BR2_PACKAGE_LUA_CQUEUES=y
        """

    def test_run(self):
        self.login()
        self.module_test("_cqueues")
        self.module_test("cqueues")
        self.module_test("cqueues.auxlib")
        self.module_test("cqueues.condition")
        self.module_test("cqueues.dns")
        self.module_test("cqueues.dns.config")
        self.module_test("cqueues.dns.hints")
        self.module_test("cqueues.dns.hosts")
        self.module_test("cqueues.dns.packet")
        self.module_test("cqueues.dns.record")
        self.module_test("cqueues.dns.resolver")
        self.module_test("cqueues.dns.resolvers")
        self.module_test("cqueues.errno")
        self.module_test("cqueues.notify")
        self.module_test("cqueues.promise")
        self.module_test("cqueues.signal")
        self.module_test("cqueues.socket")
        self.module_test("cqueues.thread")


class TestLuajitLuaCqueues(TestLuaBase):
    config = TestLuaBase.config + \
        """
        BR2_PACKAGE_LUAJIT=y
        BR2_PACKAGE_LUA_CQUEUES=y
        """

    def test_run(self):
        self.login()
        self.module_test("_cqueues")
        self.module_test("cqueues")
        self.module_test("cqueues.auxlib")
        self.module_test("cqueues.condition")
        self.module_test("cqueues.dns")
        self.module_test("cqueues.dns.config")
        self.module_test("cqueues.dns.hints")
        self.module_test("cqueues.dns.hosts")
        self.module_test("cqueues.dns.packet")
        self.module_test("cqueues.dns.record")
        self.module_test("cqueues.dns.resolver")
        self.module_test("cqueues.dns.resolvers")
        self.module_test("cqueues.errno")
        self.module_test("cqueues.notify")
        self.module_test("cqueues.promise")
        self.module_test("cqueues.signal")
        self.module_test("cqueues.socket")
        self.module_test("cqueues.thread")
