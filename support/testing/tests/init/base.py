import os
import subprocess
import infra.basetest


class InitSystemBase(infra.basetest.BRTest):

    def start_emulator(self, fs_type, kernel=None, dtb=None, init=None):
        img = os.path.join(self.builddir, "images", "rootfs.{}".format(fs_type))
        subprocess.call(["truncate", "-s", "%1M", img])

        options = ["-drive",
                   "file={},if=sd,format=raw".format(img),
                   "-M", "vexpress-a9"]

        if kernel is None:
            kernel = "builtin"
        else:
            kernel = os.path.join(self.builddir, "images", kernel)
            options.extend(["-dtb", os.path.join(self.builddir, "images",
                                                 "{}.dtb".format(dtb))])

        kernel_cmdline = ["root=/dev/mmcblk0",
                          "rootfstype={}".format(fs_type),
                          "rootwait",
                          "ro",
                          "console=ttyAMA0"]

        if init is not None:
            kernel_cmdline.extend(["init={}".format(init)])

        self.emulator.boot(arch="armv7",
                           kernel=kernel,
                           kernel_cmdline=kernel_cmdline,
                           options=options)

        if init is None:
            self.emulator.login()

    def check_init(self, path):
        cmd = "cmp /proc/1/exe {}".format(path)
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

    def check_network(self, interface, exitCode=0):
        cmd = "ip addr show {} |grep inet".format(interface)
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, exitCode)
