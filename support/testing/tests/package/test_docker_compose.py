import os

import infra.basetest


class TestDockerCompose(infra.basetest.BRTest):
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_x86_64=y
        BR2_x86_core2=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_TOOLCHAIN_EXTERNAL_CUSTOM=y
        BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD=y
        BR2_TOOLCHAIN_EXTERNAL_URL="http://autobuild.buildroot.org/toolchains/tarballs/br-x86-64-core2-full-2018.05.tar.bz2"
        BR2_TOOLCHAIN_EXTERNAL_GCC_6=y
        BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_16=y
        BR2_TOOLCHAIN_EXTERNAL_LOCALE=y
        # BR2_TOOLCHAIN_EXTERNAL_HAS_THREADS_DEBUG is not set
        BR2_TOOLCHAIN_EXTERNAL_CXX=y
        BR2_SYSTEM_DHCP="eth0"
        BR2_ROOTFS_POST_BUILD_SCRIPT="{}"
        BR2_ROOTFS_POST_SCRIPT_ARGS="{}"
        BR2_LINUX_KERNEL=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="4.19"
        BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG=y
        BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="{}"
        BR2_PACKAGE_CA_CERTIFICATES=y
        BR2_PACKAGE_CGROUPFS_MOUNT=y
        BR2_PACKAGE_DOCKER_CLI=y
        BR2_PACKAGE_DOCKER_COMPOSE=y
        BR2_PACKAGE_DOCKER_ENGINE=y
        BR2_TARGET_ROOTFS_EXT2=y
        BR2_TARGET_ROOTFS_EXT2_SIZE="512M"
        # BR2_TARGET_ROOTFS_TAR is not set
        """.format(
            infra.filepath("tests/package/copy-sample-script-to-target.sh"),
            infra.filepath("conf/docker-compose.yml"),
            infra.filepath("conf/docker-compose-kernel.config"))

    def wait_for_dockerd(self):
        # dockerd takes a while to start up
        _, _ = self.emulator.run('while [ ! -e /var/run/docker.sock ]; do sleep 1; done', 120)

    def docker_test(self):
        # will download container if not available, which may take some time
        _, exit_code = self.emulator.run('docker run --rm busybox:latest /bin/true', 120)
        self.assertEqual(exit_code, 0)

    def docker_compose_test(self):
        # will download container if not available, which may take some time
        _, exit_code = self.emulator.run('docker-compose up', 120)
        self.assertEqual(exit_code, 0)

    def test_run(self):
        kernel = os.path.join(self.builddir, "images", "bzImage")
        rootfs = os.path.join(self.builddir, "images", "rootfs.ext2")
        self.emulator.boot(arch="x86_64",
                           kernel=kernel,
                           kernel_cmdline=["root=/dev/vda", "console=ttyS0"],
                           options=["-cpu", "core2duo",
                                    "-m", "512M",
                                    "-device", "virtio-rng-pci",
                                    "-drive", "file={},format=raw,if=virtio".format(rootfs),
                                    "-net", "nic,model=virtio",
                                    "-net", "user"])
        self.emulator.login()
        self.wait_for_dockerd()
        self.docker_test()
        self.docker_compose_test()
