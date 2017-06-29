import pexpect

import infra


class Emulator(object):

    def __init__(self, builddir, downloaddir, logtofile):
        self.qemu = None
        self.downloaddir = downloaddir
        self.logfile = infra.open_log_file(builddir, "run", logtofile)

    # Start Qemu to boot the system
    #
    # arch: Qemu architecture to use
    #
    # kernel: path to the kernel image, or the special string
    # 'builtin'. 'builtin' means a pre-built kernel image will be
    # downloaded from ARTEFACTS_URL and suitable options are
    # automatically passed to qemu and added to the kernel cmdline. So
    # far only armv5, armv7 and i386 builtin kernels are available.
    # If None, then no kernel is used, and we assume a bootable device
    # will be specified.
    #
    # kernel_cmdline: array of kernel arguments to pass to Qemu -append option
    #
    # options: array of command line options to pass to Qemu
    #
    def boot(self, arch, kernel=None, kernel_cmdline=None, options=None):
        if arch in ["armv7", "armv5"]:
            qemu_arch = "arm"
        else:
            qemu_arch = arch

        qemu_cmd = ["qemu-system-{}".format(qemu_arch),
                    "-serial", "stdio",
                    "-display", "none"]

        if options:
            qemu_cmd += options

        if kernel_cmdline is None:
            kernel_cmdline = []

        if kernel:
            if kernel == "builtin":
                if arch in ["armv7", "armv5"]:
                    kernel_cmdline.append("console=ttyAMA0")

                if arch == "armv7":
                    kernel = infra.download(self.downloaddir,
                                            "kernel-vexpress")
                    dtb = infra.download(self.downloaddir,
                                         "vexpress-v2p-ca9.dtb")
                    qemu_cmd += ["-dtb", dtb]
                    qemu_cmd += ["-M", "vexpress-a9"]
                elif arch == "armv5":
                    kernel = infra.download(self.downloaddir,
                                            "kernel-versatile")
                    qemu_cmd += ["-M", "versatilepb"]

            qemu_cmd += ["-kernel", kernel]

        if kernel_cmdline:
            qemu_cmd += ["-append", " ".join(kernel_cmdline)]

        self.logfile.write("> starting qemu with '%s'\n" % " ".join(qemu_cmd))
        self.qemu = pexpect.spawn(qemu_cmd[0], qemu_cmd[1:], timeout=5)
        # We want only stdout into the log to avoid double echo
        self.qemu.logfile_read = self.logfile

    # Wait for the login prompt to appear, and then login as root with
    # the provided password, or no password if not specified.
    def login(self, password=None):
        # The login prompt can take some time to appear when running multiple
        # instances in parallel, so set the timeout to a large value
        index = self.qemu.expect(["buildroot login:", pexpect.TIMEOUT],
                                 timeout=60)
        if index != 0:
            self.logfile.write("==> System does not boot")
            raise SystemError("System does not boot")

        self.qemu.sendline("root")
        if password:
            self.qemu.expect("Password:")
            self.qemu.sendline(password)
        index = self.qemu.expect(["# ", pexpect.TIMEOUT])
        if index != 0:
            raise SystemError("Cannot login")
        self.run("dmesg -n 1")

    # Run the given 'cmd' on the target
    # return a tuple (output, exit_code)
    def run(self, cmd):
        self.qemu.sendline(cmd)
        self.qemu.expect("# ")
        # Remove double carriage return from qemu stdout so str.splitlines()
        # works as expected.
        output = self.qemu.before.replace("\r\r", "\r").splitlines()[1:]

        self.qemu.sendline("echo $?")
        self.qemu.expect("# ")
        exit_code = self.qemu.before.splitlines()[2]
        exit_code = int(exit_code)

        return output, exit_code

    def stop(self):
        if self.qemu is None:
            return
        self.qemu.terminate(force=True)
