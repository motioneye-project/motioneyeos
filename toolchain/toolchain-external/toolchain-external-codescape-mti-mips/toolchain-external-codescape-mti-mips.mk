################################################################################
#
# toolchain-external-codescape-mti-mips
#
################################################################################

TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_VERSION = 2016.05-06
TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_SITE = http://codescape-mips-sdk.imgtec.com/components/toolchain/$(TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_VERSION)
TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_STRIP_COMPONENTS = 2

ifeq ($(HOSTARCH),x86)
TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_SOURCE = Codescape.GNU.Tools.Package.$(TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_VERSION).for.MIPS.MTI.Linux.CentOS-5.x86.tar.gz
else
TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_SOURCE = Codescape.GNU.Tools.Package.$(TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_VERSION).for.MIPS.MTI.Linux.CentOS-5.x86_64.tar.gz
endif

# Special fixup for Codescape MIPS toolchains, that have bin-<abi> and
# sbin-<abi> directories. We create symlinks bin -> bin-<abi> and sbin
# -> sbin-<abi> so that the rest of Buildroot can find the toolchain
# tools in the appropriate location.
ifeq ($(BR2_MIPS_OABI32),y)
TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_BIN_DIR_SUFFIX = o32
else ifeq ($(BR2_MIPS_NABI32),y)
TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_BIN_DIR_SUFFIX = n32
else ifeq ($(BR2_MIPS_NABI64),y)
TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_BIN_DIR_SUFFIX = n64
endif

define TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_STAGING_FIXUPS
	rmdir $(STAGING_DIR)/usr/bin $(STAGING_DIR)/usr/sbin
	ln -sf bin-$(TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_BIN_DIR_SUFFIX) $(STAGING_DIR)/usr/bin
	ln -sf sbin-$(TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_BIN_DIR_SUFFIX) $(STAGING_DIR)/usr/sbin
endef

# The Codescape toolchain uses a sysroot layout that places them
# side-by-side instead of nested like multilibs. A symlink is needed
# much like for the nested sysroots which are handled in
# copy_toolchain_sysroot but there is not enough information in there
# to determine whether the sysroot layout was nested or side-by-side.
# Add the symlink here for now.
define TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_SYMLINK
	$(Q)ARCH_SYSROOT_DIR="$(call toolchain_find_sysroot,$(TOOLCHAIN_EXTERNAL_CC) $(TOOLCHAIN_EXTERNAL_CFLAGS))"; \
	ARCH_SUBDIR=`basename $${ARCH_SYSROOT_DIR}`; \
	ln -snf . $(STAGING_DIR)/$${ARCH_SUBDIR}
endef

TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_POST_INSTALL_STAGING_HOOKS += \
	TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_STAGING_FIXUPS \
	TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS_SYMLINK

$(eval $(toolchain-external-package))
