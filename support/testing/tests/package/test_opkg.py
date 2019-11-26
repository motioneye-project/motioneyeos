import os

import infra.basetest


class TestOpkg(infra.basetest.BRTest):
    # The snmpd service is used as an example for this test of a set of files
    # that can be archived up and deployed/removed to test opkg
    #
    # The post build script uses an ipk-build template and assembles the test
    # package.
    config = infra.basetest.BASIC_TOOLCHAIN_CONFIG + \
        """
        BR2_PACKAGE_NETSNMP=y
        # BR2_PACKAGE_NETSNMP_CLIENTS is not set
        # BR2_PACKAGE_NETSNMP_ENABLE_MIBS is not set
        BR2_PACKAGE_OPKG=y
        BR2_TARGET_ROOTFS_CPIO=y
        # BR2_TARGET_ROOTFS_TAR is not set
        BR2_PACKAGE_HOST_OPKG_UTILS=y
        BR2_ROOTFS_POST_BUILD_SCRIPT="{}"
        """.format(infra.filepath("tests/package/test_opkg/post-build.sh"))

    def test_run(self):
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv5",
                           kernel="builtin",
                           options=["-initrd", cpio_file])
        self.emulator.login()

        # This test sequence tests the install and removal of a running
        # service and configuration files.  It also exercises the postinst
        # and prerm scripting provided in the package archive.

        cmd = "opkg install example-snmpd-package_1.0_arm.ipk"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        cmd = "opkg list-installed | grep example-snmpd-package"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        # Check that postinst script ran to start the services
        cmd = "ps aux | grep [s]nmpd"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        # If successful, the prerm script ran to stop the service prior to
        # the removal of the service scripting and files
        cmd = "opkg remove example-snmpd-package"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 0)

        # Verify after package removal that the services is not
        # running, but let's give it some time to really stop
        # (otherwise a [snmpd] process might show up in the ps output)
        cmd = "sleep 1 && ps aux | grep [s]nmpd"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 1)

        # This folder for configs is provided by the package install and
        # should no longer be present after package removal
        cmd = "ls /etc/snmp"
        _, exit_code = self.emulator.run(cmd)
        self.assertEqual(exit_code, 1)
