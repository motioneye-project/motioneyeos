import os

import infra.basetest


class TestLxc(infra.basetest.BRTest):
    config = \
            """
            BR2_arm=y
            BR2_TOOLCHAIN_EXTERNAL=y
            BR2_LINUX_KERNEL=y
            BR2_LINUX_KERNEL_CUSTOM_VERSION=y
            BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="4.19.79"
            BR2_LINUX_KERNEL_DEFCONFIG="vexpress"
            BR2_LINUX_KERNEL_DTS_SUPPORT=y
            BR2_LINUX_KERNEL_INTREE_DTS_NAME="vexpress-v2p-ca9"
            BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES="{}"
            BR2_TARGET_GENERIC_GETTY_PORT="ttyAMA0"
            BR2_INIT_SYSTEMD=y
            BR2_PACKAGE_LXC=y
            BR2_PACKAGE_TINI=y
            BR2_PACKAGE_IPERF3=y
            BR2_ROOTFS_OVERLAY="{}"
            BR2_TARGET_ROOTFS_CPIO=y
            """.format(
              infra.filepath("tests/package/test_lxc/lxc-kernel.config"),
              infra.filepath("tests/package/test_lxc/rootfs-overlay"))

    def run_ok(self, cmd):
        self.assertRunOk(cmd, 120)

    def wait_boot(self):
        # the complete boot with systemd takes more time than what the default multipler permits
        self.emulator.timeout_multiplier *= 10
        self.emulator.login()

    def setup_run_test_container(self):
        self.run_ok("lxc-create -n lxc_iperf3 -t none -f /usr/share/lxc/config/minimal-iperf3.conf")
        self.run_ok("lxc-start -l trace -n lxc_iperf3 -o /tmp/lxc.log -L /tmp/lxc.console.log")
        # need to wait for the container to be fully started
        self.run_ok("sleep 2")
        self.run_ok("iperf3 -c 192.168.1.2 -t 2")
        # if the test fails, just cat /tmp/*.log

    def test_run(self):
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        kernel_file = os.path.join(self.builddir, "images", "zImage")
        dtb_file = os.path.join(self.builddir, "images", "vexpress-v2p-ca9.dtb")
        self.emulator.boot(arch="armv7", kernel=kernel_file,
                           kernel_cmdline=[
                                        "console=ttyAMA0,115200"],
                           options=["-initrd", cpio_file,
                                    "-dtb", dtb_file,
                                    "-M", "vexpress-a9"])
        self.wait_boot()
        self.setup_run_test_container()
