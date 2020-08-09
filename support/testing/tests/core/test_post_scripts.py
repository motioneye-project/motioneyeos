import os
import csv

import infra.basetest


class TestPostScripts(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_INIT_NONE=y
        BR2_SYSTEM_BIN_SH_NONE=y
        # BR2_PACKAGE_BUSYBOX is not set
        BR2_ROOTFS_POST_BUILD_SCRIPT="{}"
        BR2_ROOTFS_POST_FAKEROOT_SCRIPT="{}"
        BR2_ROOTFS_POST_IMAGE_SCRIPT="{}"
        BR2_ROOTFS_POST_SCRIPT_ARGS="foobar baz"
        """.format(infra.filepath("tests/core/post-build.sh"),
                   infra.filepath("tests/core/post-fakeroot.sh"),
                   infra.filepath("tests/core/post-image.sh"))

    def check_post_log_file(self, f, what, target_dir):
        lines = {}
        with open(os.path.join(self.builddir, "build", f), newline='') as csvfile:
            r = csv.reader(csvfile, delimiter=',')
            for row in r:
                lines[row[0]] = row[1]

        self.assertEqual(lines["arg1"], what)
        self.assertEqual(lines["arg2"], "foobar")
        self.assertEqual(lines["arg3"], "baz")
        self.assertEqual(lines["TARGET_DIR"], target_dir)
        self.assertEqual(lines["BUILD_DIR"], os.path.join(self.builddir, "build"))
        self.assertEqual(lines["HOST_DIR"], os.path.join(self.builddir, "host"))
        staging = os.readlink(os.path.join(self.builddir, "staging"))
        self.assertEqual(lines["STAGING_DIR"], staging)
        self.assertEqual(lines["BINARIES_DIR"], os.path.join(self.builddir, "images"))
        self.assertEqual(lines["BR2_CONFIG"], os.path.join(self.builddir, ".config"))

    def test_run(self):
        self.check_post_log_file("post-build.log",
                                 os.path.join(self.builddir, "target"),
                                 os.path.join(self.builddir, "target"))
        self.check_post_log_file("post-fakeroot.log",
                                 os.path.join(self.builddir, "build/buildroot-fs/tar/target"),
                                 os.path.join(self.builddir, "build/buildroot-fs/tar/target"))
        self.check_post_log_file("post-image.log",
                                 os.path.join(self.builddir, "images"),
                                 os.path.join(self.builddir, "target"))
