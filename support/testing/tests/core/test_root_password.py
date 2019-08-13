import os
import infra.basetest
from crypt import crypt


class TestRootPassword(infra.basetest.BRTest):
    password = "foo"
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_TARGET_ROOTFS_CPIO=y
        BR2_TARGET_ENABLE_ROOT_LOGIN=y
        BR2_TARGET_GENERIC_ROOT_PASSWD="{}"
        """.format(password)

    def test_run(self):
        # 1. Test by looking hash in the /etc/shadow
        shadow = os.path.join(self.builddir, "target", "etc", "shadow")
        with open(shadow, "r") as f:
            users = f.readlines()
            for user in users:
                s = user.split(":")
                n, h = s[0], s[1]
                if n == "root":
                    # Fail if the account is disabled or no password is required
                    self.assertTrue(h not in ["", "*"])
                    # Fail if the hash isn't right
                    self.assertEqual(crypt(self.password, h), h)

        # 2. Test by attempting to login
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        try:
            self.emulator.boot(arch="armv7", kernel="builtin",
                               options=["-initrd", cpio_file])
            self.emulator.login(self.password)
        except SystemError:
            self.fail("Unable to login with the password")
