import infra.basetest
from tests.init.base import InitSystemBase as InitSystemBase


class InitSystemSystemdBase(InitSystemBase):
    config = \
        """
        BR2_arm=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_INIT_SYSTEMD=y
        BR2_TARGET_GENERIC_GETTY_PORT="ttyAMA0"
        BR2_LINUX_KERNEL=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="4.11.3"
        BR2_LINUX_KERNEL_DEFCONFIG="vexpress"
        BR2_LINUX_KERNEL_DTS_SUPPORT=y
        BR2_LINUX_KERNEL_INTREE_DTS_NAME="vexpress-v2p-ca9"
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def check_init(self):
        super(InitSystemSystemdBase, self).check_init("/lib/systemd/systemd")

        # Test all units are OK
        output, _ = self.emulator.run("systemctl --no-pager --failed --no-legend")
        self.assertEqual(len(output), 0)

        # Test we can reach the DBus daemon
        _, exit_code = self.emulator.run("busctl --no-pager")
        self.assertEqual(exit_code, 0)

        # Test we can read at least one line from the journal
        output, _ = self.emulator.run("journalctl --no-pager --lines 1 --quiet")
        self.assertEqual(len(output), 1)


class TestInitSystemSystemdRoNetworkd(InitSystemSystemdBase):
    config = InitSystemSystemdBase.config + \
        """
        BR2_SYSTEM_DHCP="eth0"
        # BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW is not set
        BR2_ROOTFS_OVERLAY="{}"
        BR2_TARGET_ROOTFS_SQUASHFS=y
        """.format(infra.filepath("tests/init/systemd-factory"))

    def test_run(self):
        self.start_emulator("squashfs", "zImage", "vexpress-v2p-ca9")
        self.check_init()
        self.check_network("eth0")

        # This one must be executed on the target, to check that
        # the factory feature works as expected
        out, exit_code = self.emulator.run("cat /var/foo/bar")
        self.assertEqual(exit_code, 0)
        self.assertEqual(out[0], "foobar")


class TestInitSystemSystemdRwNetworkd(InitSystemSystemdBase):
    config = InitSystemSystemdBase.config + \
        """
        BR2_SYSTEM_DHCP="eth0"
        BR2_TARGET_ROOTFS_EXT2=y
        """

    def test_run(self):
        self.start_emulator("ext2", "zImage", "vexpress-v2p-ca9")
        self.check_init()
        self.check_network("eth0")


class TestInitSystemSystemdRoIfupdown(InitSystemSystemdBase):
    config = InitSystemSystemdBase.config + \
        """
        BR2_SYSTEM_DHCP="eth0"
        # BR2_PACKAGE_SYSTEMD_NETWORKD is not set
        # BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW is not set
        BR2_TARGET_ROOTFS_SQUASHFS=y
        """

    def test_run(self):
        self.start_emulator("squashfs", "zImage", "vexpress-v2p-ca9")
        self.check_init()
        self.check_network("eth0")


class TestInitSystemSystemdRwIfupdown(InitSystemSystemdBase):
    config = InitSystemSystemdBase.config + \
        """
        BR2_SYSTEM_DHCP="eth0"
        # BR2_PACKAGE_SYSTEMD_NETWORKD is not set
        # BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW is not set
        BR2_TARGET_ROOTFS_EXT2=y
        """

    def test_run(self):
        self.start_emulator("ext2", "zImage", "vexpress-v2p-ca9")
        self.check_init()
        self.check_network("eth0")


class TestInitSystemSystemdRoFull(InitSystemSystemdBase):
    config = InitSystemSystemdBase.config + \
        """
        BR2_SYSTEM_DHCP="eth0"
        # BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW is not set
        BR2_PACKAGE_SYSTEMD_JOURNAL_GATEWAY=y
        BR2_PACKAGE_SYSTEMD_BACKLIGHT=y
        BR2_PACKAGE_SYSTEMD_BINFMT=y
        BR2_PACKAGE_SYSTEMD_COREDUMP=y
        BR2_PACKAGE_SYSTEMD_FIRSTBOOT=y
        BR2_PACKAGE_SYSTEMD_HIBERNATE=y
        BR2_PACKAGE_SYSTEMD_IMPORTD=y
        BR2_PACKAGE_SYSTEMD_LOCALED=y
        BR2_PACKAGE_SYSTEMD_LOGIND=y
        BR2_PACKAGE_SYSTEMD_MACHINED=y
        BR2_PACKAGE_SYSTEMD_POLKIT=y
        BR2_PACKAGE_SYSTEMD_QUOTACHECK=y
        BR2_PACKAGE_SYSTEMD_RANDOMSEED=y
        BR2_PACKAGE_SYSTEMD_RFKILL=y
        BR2_PACKAGE_SYSTEMD_SMACK_SUPPORT=y
        BR2_PACKAGE_SYSTEMD_SYSUSERS=y
        BR2_PACKAGE_SYSTEMD_VCONSOLE=y
        BR2_TARGET_ROOTFS_SQUASHFS=y
        """

    def test_run(self):
        self.start_emulator("squashfs", "zImage", "vexpress-v2p-ca9")
        self.check_init()
        self.check_network("eth0")


class TestInitSystemSystemdRwFull(InitSystemSystemdBase):
    config = InitSystemSystemdBase.config + \
        """
        BR2_SYSTEM_DHCP="eth0"
        BR2_PACKAGE_SYSTEMD_JOURNAL_GATEWAY=y
        BR2_PACKAGE_SYSTEMD_BACKLIGHT=y
        BR2_PACKAGE_SYSTEMD_BINFMT=y
        BR2_PACKAGE_SYSTEMD_COREDUMP=y
        BR2_PACKAGE_SYSTEMD_FIRSTBOOT=y
        BR2_PACKAGE_SYSTEMD_HIBERNATE=y
        BR2_PACKAGE_SYSTEMD_IMPORTD=y
        BR2_PACKAGE_SYSTEMD_LOCALED=y
        BR2_PACKAGE_SYSTEMD_LOGIND=y
        BR2_PACKAGE_SYSTEMD_MACHINED=y
        BR2_PACKAGE_SYSTEMD_POLKIT=y
        BR2_PACKAGE_SYSTEMD_QUOTACHECK=y
        BR2_PACKAGE_SYSTEMD_RANDOMSEED=y
        BR2_PACKAGE_SYSTEMD_RFKILL=y
        BR2_PACKAGE_SYSTEMD_SMACK_SUPPORT=y
        BR2_PACKAGE_SYSTEMD_SYSUSERS=y
        BR2_PACKAGE_SYSTEMD_VCONSOLE=y
        BR2_TARGET_ROOTFS_EXT2=y
        """

    def test_run(self):
        self.start_emulator("ext2", "zImage", "vexpress-v2p-ca9")
        self.check_init()
        self.check_network("eth0")
