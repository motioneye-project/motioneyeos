import os

import infra.basetest

GLXINFO_TIMEOUT = 120


class TestGlxinfo(infra.basetest.BRTest):
    config = \
        """
        BR2_x86_core2=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_TOOLCHAIN_EXTERNAL_CUSTOM=y
        BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD=y
        BR2_TOOLCHAIN_EXTERNAL_URL="http://toolchains.bootlin.com/downloads/releases/toolchains/x86-core2/tarballs/x86-core2--glibc--bleeding-edge-2018.11-1.tar.bz2"
        BR2_TOOLCHAIN_EXTERNAL_GCC_8=y
        BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_14=y
        BR2_TOOLCHAIN_EXTERNAL_CXX=y
        BR2_TOOLCHAIN_EXTERNAL_HAS_SSP=y
        BR2_TOOLCHAIN_EXTERNAL_CUSTOM_GLIBC=y
        BR2_LINUX_KERNEL=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="4.16.7"
        BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG=y
        BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="board/qemu/x86/linux.config"
        BR2_PACKAGE_MESA3D_DEMOS=y
        BR2_PACKAGE_MESA3D=y
        BR2_PACKAGE_MESA3D_DRI_DRIVER_SWRAST=y
        BR2_PACKAGE_MESA3D_OPENGL_GLX=y
        BR2_PACKAGE_XORG7=y
        BR2_PACKAGE_XSERVER_XORG_SERVER=y
        BR2_TARGET_GENERIC_GETTY_PORT="ttyS0"
        BR2_TARGET_ROOTFS_EXT2=y
        # BR2_TARGET_ROOTFS_TAR is not set
        """

    def wait_for_xserver(self):
        # xserver takes some time to start up
        # The test case fail here if for some reason xserver is not properly installed
        _, _ = self.emulator.run('while [ ! -e /var/run/xorg.pid ]; do sleep 1; done', 120)

    def login(self):
        img = os.path.join(self.builddir, "images", "rootfs.ext2")
        kern = os.path.join(self.builddir, "images", "bzImage")
        # glxinfo overallocate memory and the minimum that seemed to work was 512MB
        self.emulator.boot(arch="i386",
                           kernel=kern,
                           kernel_cmdline=["root=/dev/vda console=ttyS0"],
                           options=["-M", "pc", "-m", "512", "-drive", "file={},if=virtio,format=raw".format(img)])
        self.emulator.login()

    def test_run(self):
        self.login()
        self.wait_for_xserver()

        # The test case verifies that the xserver with GLX is working
        cmd = "glxinfo -B -display :0"
        output, exit_code = self.emulator.run(cmd, GLXINFO_TIMEOUT)
        self.assertEqual(exit_code, 0)
        for line in output:
            self.assertNotIn("Error", line)
        # Error case: "Error: couldn't find RGB GLX visual or fbconfig"
