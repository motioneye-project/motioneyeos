import os

import infra.basetest

class TestYaffs2(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
            infra.basetest.MINIMAL_CONFIG + \
            "BR2_TARGET_ROOTFS_YAFFS2=y"

    def test_run(self):
        img = os.path.join(self.builddir, "images", "rootfs.yaffs2")
        self.assertTrue(os.path.exists(img))
