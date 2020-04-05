import infra.basetest


class TestSysLinuxBase(infra.basetest.BRTest):
    x86_toolchain_config = \
        """
        BR2_x86_i686=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD=y
        BR2_TOOLCHAIN_EXTERNAL_URL="http://toolchains.bootlin.com/downloads/releases/toolchains/x86-i686/tarballs/x86-i686--glibc--bleeding-edge-2018.11-1.tar.bz2"
        BR2_TOOLCHAIN_EXTERNAL_GCC_8=y
        BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_14=y
        BR2_TOOLCHAIN_EXTERNAL_CUSTOM_GLIBC=y
        BR2_TOOLCHAIN_EXTERNAL_CXX=y
        """

    x86_64_toolchain_config = \
        """
        BR2_x86_64=y
        BR2_x86_corei7=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_TOOLCHAIN_EXTERNAL_CUSTOM=y
        BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD=y
        BR2_TOOLCHAIN_EXTERNAL_URL="http://toolchains.bootlin.com/downloads/releases/toolchains/x86-64-core-i7/tarballs/x86-64-core-i7--glibc--stable-2018.11-1.tar.bz2"
        BR2_TOOLCHAIN_EXTERNAL_GCC_7=y
        BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_1=y
        BR2_TOOLCHAIN_EXTERNAL_CXX=y
        BR2_TOOLCHAIN_EXTERNAL_HAS_SSP=y
        BR2_TOOLCHAIN_EXTERNAL_CUSTOM_GLIBC=y
        """

    syslinux_legacy_config = \
        """
        BR2_TARGET_SYSLINUX=y
        BR2_TARGET_SYSLINUX_ISOLINUX=y
        BR2_TARGET_SYSLINUX_PXELINUX=y
        BR2_TARGET_SYSLINUX_MBR=y
        """

    syslinux_efi_config = \
        """
        BR2_TARGET_SYSLINUX=y
        BR2_TARGET_SYSLINUX_EFI=y
        """


class TestSysLinuxX86LegacyBios(TestSysLinuxBase):
    config = \
        TestSysLinuxBase.x86_toolchain_config + \
        infra.basetest.MINIMAL_CONFIG + \
        TestSysLinuxBase.syslinux_legacy_config

    def test_run(self):
        pass


class TestSysLinuxX86EFI(TestSysLinuxBase):
    config = \
        TestSysLinuxBase.x86_toolchain_config + \
        infra.basetest.MINIMAL_CONFIG + \
        TestSysLinuxBase.syslinux_efi_config

    def test_run(self):
        pass


class TestSysLinuxX86_64LegacyBios(TestSysLinuxBase):
    config = \
        TestSysLinuxBase.x86_64_toolchain_config + \
        infra.basetest.MINIMAL_CONFIG + \
        TestSysLinuxBase.syslinux_legacy_config

    def test_run(self):
        pass


class TestSysLinuxX86_64EFI(TestSysLinuxBase):
    config = \
        TestSysLinuxBase.x86_64_toolchain_config + \
        infra.basetest.MINIMAL_CONFIG + \
        TestSysLinuxBase.syslinux_efi_config

    def test_run(self):
        pass
