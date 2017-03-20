import os
import subprocess

import infra.basetest

def compare_file(file1, file2):
    return subprocess.call(["cmp", file1, file2])

class TestRootfsOverlay(infra.basetest.BRTest):

    rootfs_overlay_path = infra.filepath("tests/core/rootfs-overlay")
    rootfs_overlay = "BR2_ROOTFS_OVERLAY=\"{0}1 {0}2\"".format(rootfs_overlay_path)

    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
            infra.basetest.MINIMAL_CONFIG + \
            rootfs_overlay

    def test_run(self):
        target_file = os.path.join(self.builddir, "target", "test-file1")
        overlay_file = "{}1/test-file1".format(self.rootfs_overlay_path)
        ret = compare_file(overlay_file, target_file)
        self.assertEqual(ret, 0)

        target_file = os.path.join(self.builddir, "target", "etc", "test-file2")
        overlay_file = "{}2/etc/test-file2".format(self.rootfs_overlay_path)
        ret = compare_file(overlay_file, target_file)
        self.assertEqual(ret, 0)
