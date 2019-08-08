import os

import infra.basetest

VOLNAME_PROP = "Filesystem volume name"
REVISION_PROP = "Filesystem revision #"
FEATURES_PROP = "Filesystem features"
BLOCKCNT_PROP = "Block count"
INODECNT_PROP = "Inode count"
RESBLKCNT_PROP = "Reserved block count"

CHECK_FS_TYPE_CMD = "mount | grep '/dev/root on / type {}'"


def dumpe2fs_run(builddir, image):
    cmd = ["host/sbin/dumpe2fs", os.path.join("images", image)]
    ret = infra.run_cmd_on_host(builddir, cmd)
    return ret.strip().splitlines()


def dumpe2fs_getprop(out, prop):
    for line in out:
        fields = line.split(": ")
        if fields[0] == prop:
            return fields[1].strip()


def boot_img_and_check_fs_type(emulator, builddir, fs_type):
    img = os.path.join(builddir, "images", "rootfs.{}".format(fs_type))
    emulator.boot(arch="armv7",
                  kernel="builtin",
                  kernel_cmdline=["root=/dev/mmcblk0",
                                  "rootfstype={}".format(fs_type)],
                  options=["-drive", "file={},if=sd".format(img)])
    emulator.login()
    _, exit_code = emulator.run(CHECK_FS_TYPE_CMD.format(fs_type))
    return exit_code


class TestExt2(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_TARGET_ROOTFS_EXT2=y
        BR2_TARGET_ROOTFS_EXT2_2r0=y
        BR2_TARGET_ROOTFS_EXT2_LABEL="foobaz"
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def test_run(self):
        out = dumpe2fs_run(self.builddir, "rootfs.ext2")
        self.assertEqual(dumpe2fs_getprop(out, VOLNAME_PROP), "foobaz")
        self.assertEqual(dumpe2fs_getprop(out, REVISION_PROP), "0 (original)")

        exit_code = boot_img_and_check_fs_type(self.emulator,
                                               self.builddir, "ext2")
        self.assertEqual(exit_code, 0)


class TestExt2r1(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_TARGET_ROOTFS_EXT2=y
        BR2_TARGET_ROOTFS_EXT2_2r1=y
        BR2_TARGET_ROOTFS_EXT2_LABEL="foobar"
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def test_run(self):
        out = dumpe2fs_run(self.builddir, "rootfs.ext2")
        self.assertEqual(dumpe2fs_getprop(out, VOLNAME_PROP), "foobar")
        self.assertEqual(dumpe2fs_getprop(out, REVISION_PROP), "1 (dynamic)")
        self.assertNotIn("has_journal", dumpe2fs_getprop(out, FEATURES_PROP))

        exit_code = boot_img_and_check_fs_type(self.emulator,
                                               self.builddir, "ext2")
        self.assertEqual(exit_code, 0)


class TestExt3(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_TARGET_ROOTFS_EXT2=y
        BR2_TARGET_ROOTFS_EXT2_3=y
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def test_run(self):
        out = dumpe2fs_run(self.builddir, "rootfs.ext3")
        self.assertEqual(dumpe2fs_getprop(out, REVISION_PROP), "1 (dynamic)")
        self.assertIn("has_journal", dumpe2fs_getprop(out, FEATURES_PROP))
        self.assertNotIn("extent", dumpe2fs_getprop(out, FEATURES_PROP))

        exit_code = boot_img_and_check_fs_type(self.emulator,
                                               self.builddir, "ext3")
        self.assertEqual(exit_code, 0)


class TestExt4(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_TARGET_ROOTFS_EXT2=y
        BR2_TARGET_ROOTFS_EXT2_4=y
        BR2_TARGET_ROOTFS_EXT2_SIZE="16384"
        BR2_TARGET_ROOTFS_EXT2_INODES=3000
        BR2_TARGET_ROOTFS_EXT2_RESBLKS=10
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def test_run(self):
        out = dumpe2fs_run(self.builddir, "rootfs.ext4")
        self.assertEqual(dumpe2fs_getprop(out, REVISION_PROP), "1 (dynamic)")
        self.assertEqual(dumpe2fs_getprop(out, BLOCKCNT_PROP), "16384")
        # Yes there are 8 more inodes than requested
        self.assertEqual(dumpe2fs_getprop(out, INODECNT_PROP), "3008")
        self.assertEqual(dumpe2fs_getprop(out, RESBLKCNT_PROP), "1638")
        self.assertIn("has_journal", dumpe2fs_getprop(out, FEATURES_PROP))
        self.assertIn("extent", dumpe2fs_getprop(out, FEATURES_PROP))

        exit_code = boot_img_and_check_fs_type(self.emulator,
                                               self.builddir, "ext4")
        self.assertEqual(exit_code, 0)
