import os
import tempfile
import subprocess
import shutil

import infra.basetest


class TestRustBase(infra.basetest.BRTest):

    target = 'armv7-unknown-linux-gnueabihf'
    crate = 'hello-world'

    def login(self):
        img = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv7",
                           kernel="builtin",
                           options=["-initrd", img])
        self.emulator.login()

    def build_test_prog(self):
        hostdir = os.path.join(self.builddir, 'host')
        env = os.environ.copy()
        env["USER"] = "br-user"
        env["PATH"] = "{}:".format(os.path.join(hostdir, 'bin')) + env["PATH"]
        env["CARGO_HOME"] = os.path.join(hostdir, 'usr', 'share', 'cargo')
        env["RUST_TARGET_PATH"] = os.path.join(hostdir, 'etc', 'rustc')
        cargo = os.path.join(hostdir, 'bin', 'cargo')
        workdir = os.path.join(tempfile.mkdtemp(suffix='-br2-testing-rust'),
                               self.crate)
        manifest = os.path.join(workdir, 'Cargo.toml')
        prog = os.path.join(workdir, 'target', self.target, 'debug', self.crate)

        cmd = [cargo, 'init', '--bin', '--vcs', 'none', '-vv', workdir]
        ret = subprocess.call(cmd,
                              stdout=self.b.logfile,
                              stderr=self.b.logfile,
                              env=env)
        if ret != 0:
            raise SystemError("Cargo init failed")

        cmd = [
            cargo, 'build', '-vv', '--target', self.target,
            '--manifest-path', manifest
        ]
        ret = subprocess.call(cmd,
                              stdout=self.b.logfile,
                              stderr=self.b.logfile,
                              env=env)
        if ret != 0:
            raise SystemError("Cargo build failed")

        shutil.copy(prog, os.path.join(self.builddir, 'target', 'usr', 'bin'))
        self.b.build()
        shutil.rmtree(workdir)


class TestRustBin(TestRustBase):
    config = \
        """
        BR2_arm=y
        BR2_cortex_a9=y
        BR2_ARM_ENABLE_NEON=y
        BR2_ARM_ENABLE_VFP=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_TARGET_GENERIC_GETTY_PORT="ttyAMA0"
        BR2_SYSTEM_DHCP="eth0"
        BR2_LINUX_KERNEL=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="4.11.3"
        BR2_LINUX_KERNEL_DEFCONFIG="vexpress"
        BR2_LINUX_KERNEL_DTS_SUPPORT=y
        BR2_LINUX_KERNEL_INTREE_DTS_NAME="vexpress-v2p-ca9"
        BR2_TARGET_ROOTFS_CPIO=y
        # BR2_TARGET_ROOTFS_TAR is not set
        BR2_PACKAGE_HOST_CARGO=y
        BR2_PACKAGE_HOST_RUSTC=y
        """

    def test_run(self):
        self.build_test_prog()
        self.login()
        _, exit_code = self.emulator.run(self.crate)
        self.assertEqual(exit_code, 0)


class TestRust(TestRustBase):
    config = \
        """
        BR2_arm=y
        BR2_cortex_a9=y
        BR2_ARM_ENABLE_NEON=y
        BR2_ARM_ENABLE_VFP=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_TARGET_GENERIC_GETTY_PORT="ttyAMA0"
        BR2_SYSTEM_DHCP="eth0"
        BR2_LINUX_KERNEL=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="4.11.3"
        BR2_LINUX_KERNEL_DEFCONFIG="vexpress"
        BR2_LINUX_KERNEL_DTS_SUPPORT=y
        BR2_LINUX_KERNEL_INTREE_DTS_NAME="vexpress-v2p-ca9"
        BR2_TARGET_ROOTFS_CPIO=y
        # BR2_TARGET_ROOTFS_TAR is not set
        BR2_PACKAGE_HOST_CARGO=y
        BR2_PACKAGE_HOST_RUSTC=y
        BR2_PACKAGE_HOST_RUST=y
        """

    def test_run(self):
        self.build_test_prog()
        self.login()
        _, exit_code = self.emulator.run(self.crate)
        self.assertEqual(exit_code, 0)
