import os
import subprocess
import json

import infra.basetest


class TestHardeningBase(infra.basetest.BRTest):
    config = \
        """
        BR2_powerpc64=y
        BR2_powerpc_e5500=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD=y
        BR2_TOOLCHAIN_EXTERNAL_URL="https://toolchains.bootlin.com/downloads/releases/toolchains/powerpc64-e5500/tarballs/powerpc64-e5500--glibc--stable-2018.02-2.tar.bz2"
        BR2_TOOLCHAIN_EXTERNAL_GCC_6=y
        BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_1=y
        BR2_TOOLCHAIN_EXTERNAL_CUSTOM_GLIBC=y
        BR2_TOOLCHAIN_EXTERNAL_CXX=y
        BR2_PACKAGE_LIGHTTPD=y
        BR2_PACKAGE_HOST_CHECKSEC=y
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    checksec_files = ["usr/sbin/lighttpd", "bin/busybox"]

    def checksec_run(self, target_file):
        filepath = os.path.join(self.builddir, "target", target_file)
        cmd = ["host/bin/checksec", "--output", "json", "--file", filepath]
        # Checksec is being used for elf file analysis only.  There are no
        # assumptions of target/run-time checks as part of this testing.
        ret = subprocess.check_output(cmd,
                                      stderr=open(os.devnull, "w"),
                                      cwd=self.builddir,
                                      env={"LANG": "C"})
        return json.loads(ret)


class TestRelro(TestHardeningBase):
    config = TestHardeningBase.config + \
        """
        BR2_RELRO_FULL=y
        """

    def test_run(self):
        for f in self.checksec_files:
            out = self.checksec_run(f)
            self.assertEqual(out["file"]["relro"], "full")
            self.assertEqual(out["file"]["pie"], "yes")


class TestRelroPartial(TestHardeningBase):
    config = TestHardeningBase.config + \
        """
        BR2_RELRO_PARTIAL=y
        """

    def test_run(self):
        for f in self.checksec_files:
            out = self.checksec_run(f)
            self.assertEqual(out["file"]["relro"], "partial")
            self.assertEqual(out["file"]["pie"], "no")


class TestSspNone(TestHardeningBase):
    config = TestHardeningBase.config + \
        """
        BR2_SSP_NONE=y
        """

    def test_run(self):
        for f in self.checksec_files:
            out = self.checksec_run(f)
            self.assertEqual(out["file"]["canary"], "no")


class TestSspStrong(TestHardeningBase):
    config = TestHardeningBase.config + \
        """
        BR2_SSP_STRONG=y
        """

    def test_run(self):
        for f in self.checksec_files:
            out = self.checksec_run(f)
            self.assertEqual(out["file"]["canary"], "yes")


class TestFortifyNone(TestHardeningBase):
    config = TestHardeningBase.config + \
        """
        BR2_FORTIFY_SOURCE_NONE=y
        """

    def test_run(self):
        for f in self.checksec_files:
            out = self.checksec_run(f)
            self.assertEqual(out["file"]["fortified"], "0")


class TestFortifyConserv(TestHardeningBase):
    config = TestHardeningBase.config + \
        """
        BR2_FORTIFY_SOURCE_1=y
        """

    def test_run(self):
        for f in self.checksec_files:
            out = self.checksec_run(f)
            self.assertNotEqual(out["file"]["fortified"], "0")
