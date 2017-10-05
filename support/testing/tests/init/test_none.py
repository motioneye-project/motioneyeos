import pexpect

import infra.basetest
from tests.init.base import InitSystemBase as InitSystemBase


class TestInitSystemNone(InitSystemBase):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_INIT_NONE=y
        # BR2_TARGET_ROOTFS_TAR is not set
        BR2_TARGET_ROOTFS_SQUASHFS=y
        """

    def test_run(self):
        self.start_emulator(fs_type="squashfs", init="/bin/sh")
        index = self.emulator.qemu.expect(["/bin/sh: can't access tty; job control turned off", pexpect.TIMEOUT], timeout=60)
        if index != 0:
            self.emulator.logfile.write("==> System does not boot")
            raise SystemError("System does not boot")
        index = self.emulator.qemu.expect(["#", pexpect.TIMEOUT], timeout=60)
        if index != 0:
            self.emulator.logfile.write("==> System does not boot")
            raise SystemError("System does not boot")

        out, exit_code = self.emulator.run("sh -c 'echo $PPID'")
        self.assertEqual(exit_code, 0)
        self.assertEqual(out[0], "1")

        _, exit_code = self.emulator.run("mount -t proc none /proc")
        self.assertEqual(exit_code, 0)

        self.check_init("/bin/sh")
