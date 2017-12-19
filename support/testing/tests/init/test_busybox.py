import infra.basetest
from tests.init.base import InitSystemBase as InitSystemBase


class InitSystemBusyboxBase(InitSystemBase):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def check_init(self):
        super(InitSystemBusyboxBase, self).check_init("/bin/busybox")


class TestInitSystemBusyboxRo(InitSystemBusyboxBase):
    config = InitSystemBusyboxBase.config + \
        """
        # BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW is not set
        BR2_TARGET_ROOTFS_SQUASHFS=y
        """

    def test_run(self):
        self.start_emulator("squashfs")
        self.check_init()
        self.check_network("eth0", 1)


class TestInitSystemBusyboxRw(InitSystemBusyboxBase):
    config = InitSystemBusyboxBase.config + \
        """
        BR2_TARGET_ROOTFS_EXT2=y
        """

    def test_run(self):
        self.start_emulator("ext2")
        self.check_init()
        self.check_network("eth0", 1)


class TestInitSystemBusyboxRoNet(InitSystemBusyboxBase):
    config = InitSystemBusyboxBase.config + \
        """
        BR2_SYSTEM_DHCP="eth0"
        # BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW is not set
        BR2_TARGET_ROOTFS_SQUASHFS=y
        """

    def test_run(self):
        self.start_emulator("squashfs")
        self.check_init()
        self.check_network("eth0")


class TestInitSystemBusyboxRwNet(InitSystemBusyboxBase):
    config = InitSystemBusyboxBase.config + \
        """
        BR2_SYSTEM_DHCP="eth0"
        BR2_TARGET_ROOTFS_EXT2=y
        """

    def test_run(self):
        self.start_emulator("ext2")
        self.check_init()
        self.check_network("eth0")
