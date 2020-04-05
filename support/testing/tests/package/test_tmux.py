import os

import infra.basetest


class TestTmux(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_PACKAGE_TMUX=y
        BR2_TARGET_ROOTFS_CPIO=y
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def test_run(self):
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv5",
                           kernel="builtin",
                           options=["-initrd", cpio_file])
        self.emulator.login()

        cmd = "tmux -V"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        cmd = "tmux -C </dev/null"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        cmd = "tmux split"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        cmd = "tmux new-window"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        cmd = "tmux list-windows"
        output, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)
        self.assertIn("(2 panes)", output[0])
        self.assertIn("(1 panes)", output[1])
