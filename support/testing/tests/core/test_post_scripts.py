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
        BR2_ROOTFS_POST_IMAGE_SCRIPT="{}"
        BR2_ROOTFS_POST_SCRIPT_ARGS="foobar baz"
        """.format(infra.filepath("tests/core/post-build.sh"),
                   infra.filepath("tests/core/post-image.sh"))

    def check_post_log_file(self, path, what):
        lines = {}
        with open(path, 'rb') as csvfile:
            r = csv.reader(csvfile, delimiter=',')
            for row in r:
                lines[row[0]] = row[1]

        self.assertEqual(lines["arg1"], os.path.join(self.builddir, what))
        self.assertEqual(lines["arg2"], "foobar")
        self.assertEqual(lines["arg3"], "baz")
        self.assertEqual(lines["TARGET_DIR"], os.path.join(self.builddir, "target"))
        self.assertEqual(lines["BUILD_DIR"], os.path.join(self.builddir, "build"))
        self.assertEqual(lines["HOST_DIR"], os.path.join(self.builddir, "host"))
        staging = os.readlink(os.path.join(self.builddir, "staging"))
        self.assertEqual(lines["STAGING_DIR"], staging)
        self.assertEqual(lines["BINARIES_DIR"], os.path.join(self.builddir, "images"))
        self.assertEqual(lines["BR2_CONFIG"], os.path.join(self.builddir, ".config"))

    def test_run(self):
        f = os.path.join(self.builddir, "build", "post-build.log")
        self.check_post_log_file(f, "target")
        f = os.path.join(self.builddir, "build", "post-image.log")
        self.check_post_log_file(f, "images")
