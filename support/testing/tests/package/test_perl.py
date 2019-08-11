import os

import infra.basetest


class TestPerlBase(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_TARGET_ROOTFS_CPIO=y
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def login(self):
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv5",
                           kernel="builtin",
                           options=["-initrd", cpio_file])
        self.emulator.login()

    def module_test(self, module, script="1"):
        cmd = "perl -M{} -e '{}'".format(module, script)
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)


class TestPerl(TestPerlBase):
    config = TestPerlBase.config + \
        """
        BR2_PACKAGE_PERL=y
        """

    def version_test(self):
        cmd = "perl -v"
        output, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)
        self.assertIn("This is perl 5", output[1])

    def core_modules_test(self):
        self.module_test("Cwd")
        self.module_test("Data::Dumper")
        self.module_test("Devel::Peek")
        self.module_test("Digest::MD5")
        self.module_test("Digest::SHA")
        self.module_test("Encode")
        self.module_test("Fcntl")
        self.module_test("File::Glob")
        self.module_test("Hash::Util")
        self.module_test("I18N::Langinfo")
        self.module_test("IO::Handle")
        self.module_test("IPC::SysV")
        self.module_test("List::Util")
        self.module_test("MIME::Base64")
        self.module_test("POSIX")
        self.module_test("Socket")
        self.module_test("Storable")
        self.module_test("Sys::Hostname")
        self.module_test("Sys::Syslog")
        self.module_test("Time::HiRes")
        self.module_test("Time::Piece")
        self.module_test("Unicode::Collate")
        self.module_test("Unicode::Normalize")

    def test_run(self):
        self.login()
        self.version_test()
        self.core_modules_test()
