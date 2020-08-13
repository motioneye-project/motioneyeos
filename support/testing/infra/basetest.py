import unittest
import os
import datetime

from infra.builder import Builder
from infra.emulator import Emulator

BASIC_TOOLCHAIN_CONFIG = \
    """
    BR2_arm=y
    BR2_TOOLCHAIN_EXTERNAL=y
    BR2_TOOLCHAIN_EXTERNAL_CUSTOM=y
    BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD=y
    BR2_TOOLCHAIN_EXTERNAL_URL="https://toolchains.bootlin.com/downloads/releases/toolchains/armv5-eabi/tarballs/armv5-eabi--uclibc--bleeding-edge-2018.11-1.tar.bz2"
    BR2_TOOLCHAIN_EXTERNAL_GCC_8=y
    BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_14=y
    BR2_TOOLCHAIN_EXTERNAL_LOCALE=y
    BR2_TOOLCHAIN_HAS_THREADS_DEBUG=y
    BR2_TOOLCHAIN_EXTERNAL_CXX=y
    """

MINIMAL_CONFIG = \
    """
    BR2_INIT_NONE=y
    BR2_SYSTEM_BIN_SH_NONE=y
    # BR2_PACKAGE_BUSYBOX is not set
    # BR2_TARGET_ROOTFS_TAR is not set
    """


class BRConfigTest(unittest.TestCase):
    config = None
    br2_external = list()
    downloaddir = None
    outputdir = None
    logtofile = True
    keepbuilds = False
    jlevel = 0
    timeout_multiplier = 1

    def __init__(self, names):
        super(BRConfigTest, self).__init__(names)
        self.testname = self.__class__.__name__
        self.builddir = self.outputdir and os.path.join(self.outputdir, self.testname)
        self.config += '\nBR2_DL_DIR="{}"\n'.format(self.downloaddir)
        self.config += "\nBR2_JLEVEL={}\n".format(self.jlevel)

    def show_msg(self, msg):
        print("{} {:40s} {}".format(datetime.datetime.now().strftime("%H:%M:%S"),
                                    self.testname, msg))

    def setUp(self):
        self.show_msg("Starting")
        self.b = Builder(self.config, self.builddir, self.logtofile)

        if not self.keepbuilds:
            self.b.delete()

        if not self.b.is_finished():
            self.b.configure(make_extra_opts=["BR2_EXTERNAL={}".format(":".join(self.br2_external))])

    def tearDown(self):
        self.show_msg("Cleaning up")
        if self.b and not self.keepbuilds:
            self.b.delete()


class BRTest(BRConfigTest):
    def __init__(self, names):
        super(BRTest, self).__init__(names)
        self.emulator = None

    def setUp(self):
        super(BRTest, self).setUp()
        if not self.b.is_finished():
            self.show_msg("Building")
            self.b.build()
            self.show_msg("Building done")

        self.emulator = Emulator(self.builddir, self.downloaddir,
                                 self.logtofile, self.timeout_multiplier)

    def tearDown(self):
        if self.emulator:
            self.emulator.stop()
        super(BRTest, self).tearDown()

    # Run the given 'cmd' with a 'timeout' on the target and
    # assert that the command succeeded
    def assertRunOk(self, cmd, timeout=-1):
        _, exit_code = self.emulator.run(cmd, timeout)
        self.assertEqual(exit_code, 0)
