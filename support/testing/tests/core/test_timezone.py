import os

import infra.basetest

def boot_armv5_cpio(emulator, builddir):
        img = os.path.join(builddir, "images", "rootfs.cpio")
        emulator.boot(arch="armv5", kernel="builtin",
                      options=["-initrd", img])
        emulator.login()

class TestNoTimezone(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
             """
# BR2_TARGET_TZ_INFO is not set
BR2_TARGET_ROOTFS_CPIO=y
# BR2_TARGET_ROOTFS_TAR is not set
"""

    def test_run(self):
        boot_armv5_cpio(self.emulator, self.builddir)
        tz, _ = self.emulator.run("TZ=UTC date +%Z")
        self.assertEqual(tz[0].strip(), "UTC")
        tz, _ = self.emulator.run("TZ=America/Los_Angeles date +%Z")
        self.assertEqual(tz[0].strip(), "UTC")

class TestGlibcAllTimezone(infra.basetest.BRTest):
    config = """
BR2_arm=y
BR2_TOOLCHAIN_EXTERNAL=y
BR2_TARGET_TZ_INFO=y
BR2_TARGET_ROOTFS_CPIO=y
# BR2_TARGET_ROOTFS_TAR is not set
"""

    def test_run(self):
        boot_armv5_cpio(self.emulator, self.builddir)
        tz, _ = self.emulator.run("date +%Z")
        self.assertEqual(tz[0].strip(), "UTC")
        tz, _ = self.emulator.run("TZ=UTC date +%Z")
        self.assertEqual(tz[0].strip(), "UTC")
        tz, _ = self.emulator.run("TZ=America/Los_Angeles date +%Z")
        self.assertEqual(tz[0].strip(), "PST")
        tz, _ = self.emulator.run("TZ=Europe/Paris date +%Z")
        self.assertEqual(tz[0].strip(), "CET")

class TestGlibcNonDefaultLimitedTimezone(infra.basetest.BRTest):
    config = """
BR2_arm=y
BR2_TOOLCHAIN_EXTERNAL=y
BR2_TARGET_TZ_INFO=y
BR2_TARGET_TZ_ZONELIST="northamerica"
BR2_TARGET_LOCALTIME="America/New_York"
BR2_TARGET_ROOTFS_CPIO=y
# BR2_TARGET_ROOTFS_TAR is not set
"""

    def test_run(self):
        boot_armv5_cpio(self.emulator, self.builddir)
        tz, _ = self.emulator.run("date +%Z")
        self.assertEqual(tz[0].strip(), "EST")
        tz, _ = self.emulator.run("TZ=UTC date +%Z")
        self.assertEqual(tz[0].strip(), "UTC")
        tz, _ = self.emulator.run("TZ=America/Los_Angeles date +%Z")
        self.assertEqual(tz[0].strip(), "PST")
        tz, _ = self.emulator.run("TZ=Europe/Paris date +%Z")
        self.assertEqual(tz[0].strip(), "Europe")
