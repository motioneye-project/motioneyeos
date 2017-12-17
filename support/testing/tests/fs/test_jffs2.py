import os
import subprocess

import infra.basetest


def jffs2dump_find_file(files_list, fname):
    for file_name in files_list:
        file_name = file_name.strip()
        if file_name.startswith("Dirent") and file_name.endswith(fname):
            return True
    return False


class TestJffs2(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_TARGET_ROOTFS_JFFS2=y
        BR2_TARGET_ROOTFS_JFFS2_CUSTOM=y
        BR2_TARGET_ROOTFS_JFFS2_CUSTOM_EBSIZE=0x80000
        BR2_TARGET_ROOTFS_JFFS2_NOCLEANMARKER=y
        BR2_TARGET_ROOTFS_JFFS2_PAD=y
        BR2_TARGET_ROOTFS_JFFS2_PADSIZE=0x4000000
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    # TODO: there are some scary JFFS2 messages when one starts to
    # write files in the rootfs: "jffs2: Newly-erased block contained
    # word 0x0 at offset 0x046c0000". To be investigated.

    def test_run(self):
        img = os.path.join(self.builddir, "images", "rootfs.jffs2")
        out = subprocess.check_output(["host/sbin/jffs2dump", "-c", img],
                                      cwd=self.builddir,
                                      env={"LANG": "C"})
        out = out.splitlines()
        self.assertTrue(jffs2dump_find_file(out, "busybox"))

        self.emulator.boot(arch="armv7",
                           kernel="builtin",
                           kernel_cmdline=["root=/dev/mtdblock0",
                                           "rootfstype=jffs2"],
                           options=["-drive", "file={},if=pflash".format(img)])
        self.emulator.login()
        cmd = "mount | grep '/dev/root on / type jffs2'"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)
