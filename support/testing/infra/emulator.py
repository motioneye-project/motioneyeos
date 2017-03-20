import socket
import subprocess
import telnetlib

import infra
import infra.basetest

# TODO: Most of the telnet stuff need to be replaced by stdio/pexpect to discuss
# with the qemu machine.
class Emulator(object):

    def __init__(self, builddir, downloaddir, logtofile):
        self.qemu = None
        self.__tn = None
        self.downloaddir = downloaddir
        self.log = ""
        self.log_file = "{}-run.log".format(builddir)
        if logtofile is None:
            self.log_file = None

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
                    "-serial", "telnet::1234,server",
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

        with infra.smart_open(self.log_file) as lfh:
            lfh.write("> starting qemu with '%s'\n" % " ".join(qemu_cmd))
            self.qemu = subprocess.Popen(qemu_cmd, stdout=lfh, stderr=lfh)

        # Wait for the telnet port to appear and connect to it.
        while True:
            try:
                self.__tn = telnetlib.Telnet("localhost", 1234)
                if self.__tn:
                    break
            except socket.error:
                continue

    def __read_until(self, waitstr, timeout=5):
        data = self.__tn.read_until(waitstr, timeout)
        self.log += data
        with infra.smart_open(self.log_file) as lfh:
            lfh.write(data)
        return data

    def __write(self, wstr):
        self.__tn.write(wstr)

    # Wait for the login prompt to appear, and then login as root with
    # the provided password, or no password if not specified.
    def login(self, password=None):
        self.__read_until("buildroot login:", 10)
        if "buildroot login:" not in self.log:
            with infra.smart_open(self.log_file) as lfh:
                lfh.write("==> System does not boot")
            raise SystemError("System does not boot")

        self.__write("root\n")
        if password:
            self.__read_until("Password:")
            self.__write(password + "\n")
        self.__read_until("# ")
        if "# " not in self.log:
            raise SystemError("Cannot login")
        self.run("dmesg -n 1")

    # Run the given 'cmd' on the target
    # return a tuple (output, exit_code)
    def run(self, cmd):
        self.__write(cmd + "\n")
        output = self.__read_until("# ")
        output = output.strip().splitlines()
        output = output[1:len(output)-1]

        self.__write("echo $?\n")
        exit_code = self.__read_until("# ")
        exit_code = exit_code.strip().splitlines()[1]
        exit_code = int(exit_code)

        return output, exit_code

    def stop(self):
        if self.qemu is None:
            return
        self.qemu.terminate()
        self.qemu.kill()
