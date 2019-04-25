import os

import infra.basetest


class TestOpenJdk(infra.basetest.BRTest):
    br2_external = [infra.filepath("tests/package/br2-external/openjdk")]
    config = \
        """
        BR2_aarch64=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_TARGET_GENERIC_GETTY_PORT="ttyAMA0"
        BR2_LINUX_KERNEL=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="4.16.7"
        BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG=y
        BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="board/qemu/aarch64-virt/linux.config"
        BR2_LINUX_KERNEL_NEEDS_HOST_OPENSSL=y
        BR2_TARGET_ROOTFS_CPIO=y
        BR2_TARGET_ROOTFS_CPIO_GZIP=y
        BR2_PACKAGE_XORG7=y
        BR2_PACKAGE_OPENJDK=y
        BR2_PACKAGE_OPENJDK_HELLO_WORLD=y
        BR2_PACKAGE_OPENJDK_JNI_TEST=y
        """

    def login(self):
        img = os.path.join(self.builddir, "images", "rootfs.cpio.gz")
        kern = os.path.join(self.builddir, "images", "Image")
        self.emulator.boot(arch="aarch64",
                           kernel=kern,
                           kernel_cmdline=["console=ttyAMA0"],
                           options=["-M", "virt", "-cpu", "cortex-a57", "-m", "512M", "-initrd", img])
        self.emulator.login()

    def test_run(self):
        self.login()

        cmd = "java -cp /usr/bin HelloWorld"
        output, exit_code = self.emulator.run(cmd, 120)
        print(output)
        self.assertEqual(exit_code, 0)
        self.assertEqual(output, ["Hello, World"])

        cmd = "java -cp /usr/bin JniTest"
        output, exit_code = self.emulator.run(cmd, 120)
        print(output)
        self.assertEqual(exit_code, 0)
