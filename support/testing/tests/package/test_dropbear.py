import os

import infra.basetest


class TestDropbear(infra.basetest.BRTest):
    passwd = "testpwd"
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_TARGET_GENERIC_ROOT_PASSWD="{}"
        BR2_SYSTEM_DHCP="eth0"
        BR2_PACKAGE_DROPBEAR=y
        BR2_PACKAGE_SSHPASS=y
        BR2_TARGET_ROOTFS_CPIO=y
        # BR2_TARGET_ROOTFS_TAR is not set
        """.format(passwd)

    def test_run(self):
        img = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv5",
                           kernel="builtin",
                           options=["-initrd", img,
                                    "-net", "nic",
                                    "-net", "user"])
        self.emulator.login(self.passwd)
        cmd = "netstat -ltn 2>/dev/null | grep 0.0.0.0:22"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        cmd = "sshpass -p {} ssh -y localhost /bin/true".format(self.passwd)
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)
