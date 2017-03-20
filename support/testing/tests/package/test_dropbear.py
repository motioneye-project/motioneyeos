import os

import infra.basetest

class TestDropbear(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
"""
BR2_TARGET_GENERIC_ROOT_PASSWD="testpwd"
BR2_SYSTEM_DHCP="eth0"
BR2_PACKAGE_DROPBEAR=y
BR2_TARGET_ROOTFS_CPIO=y
# BR2_TARGET_ROOTFS_TAR is not set
"""

    def test_run(self):
        img = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv5",
                           kernel="builtin",
                           options=["-initrd", img,
                                    "-net", "nic",
                                    "-net", "user,hostfwd=tcp::2222-:22"])
        self.emulator.login("testpwd")
        cmd = "netstat -ltn 2>/dev/null | grep 0.0.0.0:22"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)
        # Would be useful to try to login through SSH here, through
        # localhost:2222, though it is not easy to pass the ssh
        # password on the command line.
