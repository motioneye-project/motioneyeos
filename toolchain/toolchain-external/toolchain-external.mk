################################################################################
#
# toolchain-external
#
################################################################################

TOOLCHAIN_EXTERNAL_ADD_TOOLCHAIN_DEPENDENCY = NO

# musl does not provide an implementation for sys/queue.h or sys/cdefs.h.
# So, add the musl-compat-headers package that will install those files,
# into the staging directory:
#   sys/queue.h:  header from NetBSD
#   sys/cdefs.h:  minimalist header bundled in Buildroot
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
TOOLCHAIN_EXTERNAL_DEPENDENCIES += musl-compat-headers
endif

# All the definition that are common between the toolchain-external
# generic package and the toolchain-external-package infrastructure
# can be found in pkg-toolchain-external.mk

# Legacy toolchains that don't use the toolchain-external-package infrastructure
# yet. We can recognise that because no provider is set.
ifeq ($(call qstrip,$(BR2_PACKAGE_PROVIDES_TOOLCHAIN_EXTERNAL)),)

# Now we are the provider. However, we can't set it to ourselves or we'll get a
# circular dependency. Let's set it to a target that we always depend on
# instead.
BR2_PACKAGE_PROVIDES_TOOLCHAIN_EXTERNAL = skeleton

TOOLCHAIN_EXTERNAL_INSTALL_STAGING = YES

# In fact, we don't need to download the toolchain, since it is already
# available on the system, so force the site and source to be empty so
# that nothing will be downloaded/extracted.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_PREINSTALLED),y)
TOOLCHAIN_EXTERNAL_SITE =
TOOLCHAIN_EXTERNAL_SOURCE =
endif

# The Codescape toolchain uses a sysroot layout that places them
# side-by-side instead of nested like multilibs. A symlink is needed
# much like for the nested sysroots which are handled in
# copy_toolchain_sysroot but there is not enough information in there
# to determine whether the sysroot layout was nested or side-by-side.
# Add the symlink here for now.
define TOOLCHAIN_EXTERNAL_CODESCAPE_MIPS_SYMLINK
	$(Q)ARCH_SYSROOT_DIR="$(call toolchain_find_sysroot,$(TOOLCHAIN_EXTERNAL_CC) $(TOOLCHAIN_EXTERNAL_CFLAGS))"; \
	ARCH_SUBDIR=`basename $${ARCH_SYSROOT_DIR}`; \
	ln -snf . $(STAGING_DIR)/$${ARCH_SUBDIR}
endef

# Special fixup for Codescape MIPS toolchains, that have bin-<abi> and
# sbin-<abi> directories. We create symlinks bin -> bin-<abi> and sbin
# -> sbin-<abi> so that the rest of Buildroot can find the toolchain
# tools in the appropriate location.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESCAPE_IMG_MIPS)$(BR2_TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS),y)
ifeq ($(BR2_MIPS_OABI32),y)
TOOLCHAIN_EXTERNAL_CODESCAPE_MIPS_BIN_DIR_SUFFIX = o32
else ifeq ($(BR2_MIPS_NABI32),y)
TOOLCHAIN_EXTERNAL_CODESCAPE_MIPS_BIN_DIR_SUFFIX = n32
else ifeq ($(BR2_MIPS_NABI64),y)
TOOLCHAIN_EXTERNAL_CODESCAPE_MIPS_BIN_DIR_SUFFIX = n64
endif

define TOOLCHAIN_EXTERNAL_CODESCAPE_MIPS_STAGING_FIXUPS
	rmdir $(STAGING_DIR)/usr/bin $(STAGING_DIR)/usr/sbin
	ln -sf bin-$(TOOLCHAIN_EXTERNAL_CODESCAPE_MIPS_BIN_DIR_SUFFIX) $(STAGING_DIR)/usr/bin
	ln -sf sbin-$(TOOLCHAIN_EXTERNAL_CODESCAPE_MIPS_BIN_DIR_SUFFIX) $(STAGING_DIR)/usr/sbin
endef
endif

# Special handling for Blackfin toolchain, because of the split in two
# tarballs, and the organization of tarball contents. The tarballs
# contain ./opt/uClinux/{bfin-uclinux,bfin-linux-uclibc} directories,
# which themselves contain the toolchain. This is why we strip more
# components than usual.
define TOOLCHAIN_EXTERNAL_BLACKFIN_UCLIBC_EXTRA_EXTRACT
	$(call suitable-extractor,$(TOOLCHAIN_EXTERNAL_EXTRA_DOWNLOADS)) $(DL_DIR)/$(TOOLCHAIN_EXTERNAL_EXTRA_DOWNLOADS) | \
		$(TAR) --strip-components=3 --hard-dereference -C $(@D) $(TAR_OPTIONS) -
endef

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_ARM),y)
TOOLCHAIN_EXTERNAL_SITE = http://sourcery.mentor.com/public/gnu_toolchain/arm-none-linux-gnueabi
TOOLCHAIN_EXTERNAL_SOURCE = arm-2014.05-29-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_ARAGO_ARMV7A),y)
TOOLCHAIN_EXTERNAL_SITE = http://software-dl.ti.com/sdoemb/sdoemb_public_sw/arago_toolchain/2011_09/exports
TOOLCHAIN_EXTERNAL_SOURCE = arago-2011.09-armv7a-linux-gnueabi-sdk.tar.bz2
TOOLCHAIN_EXTERNAL_ACTUAL_SOURCE_TARBALL = arago-toolchain-2011.09-sources.tar.bz2
define TOOLCHAIN_EXTERNAL_FIXUP_CMDS
	mv $(@D)/arago-2011.09/armv7a/* $(@D)/
	rm -rf $(@D)/arago-2011.09/
endef
TOOLCHAIN_EXTERNAL_POST_EXTRACT_HOOKS += TOOLCHAIN_EXTERNAL_FIXUP_CMDS
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_ARAGO_ARMV5TE),y)
TOOLCHAIN_EXTERNAL_SITE = http://software-dl.ti.com/sdoemb/sdoemb_public_sw/arago_toolchain/2011_09/exports
TOOLCHAIN_EXTERNAL_SOURCE = arago-2011.09-armv5te-linux-gnueabi-sdk.tar.bz2
TOOLCHAIN_EXTERNAL_ACTUAL_SOURCE_TARBALL = arago-toolchain-2011.09-sources.tar.bz2
define TOOLCHAIN_EXTERNAL_FIXUP_CMDS
	mv $(@D)/arago-2011.09/armv5te/* $(@D)/
	rm -rf $(@D)/arago-2011.09/
endef
TOOLCHAIN_EXTERNAL_POST_EXTRACT_HOOKS += TOOLCHAIN_EXTERNAL_FIXUP_CMDS
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_LINARO_ARM),y)
TOOLCHAIN_EXTERNAL_SITE = https://releases.linaro.org/components/toolchain/binaries/5.3-2016.05/arm-linux-gnueabihf
ifeq ($(HOSTARCH),x86)
TOOLCHAIN_EXTERNAL_SOURCE = gcc-linaro-5.3.1-2016.05-i686_arm-linux-gnueabihf.tar.xz
else
TOOLCHAIN_EXTERNAL_SOURCE = gcc-linaro-5.3.1-2016.05-x86_64_arm-linux-gnueabihf.tar.xz
endif
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_LINARO_ARMEB),y)
TOOLCHAIN_EXTERNAL_SITE = https://releases.linaro.org/components/toolchain/binaries/5.3-2016.05/armeb-linux-gnueabihf
ifeq ($(HOSTARCH),x86)
TOOLCHAIN_EXTERNAL_SOURCE = gcc-linaro-5.3.1-2016.05-i686_armeb-linux-gnueabihf.tar.xz
else
TOOLCHAIN_EXTERNAL_SOURCE = gcc-linaro-5.3.1-2016.05-x86_64_armeb-linux-gnueabihf.tar.xz
endif
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_MIPS),y)
TOOLCHAIN_EXTERNAL_SITE = http://sourcery.mentor.com/public/gnu_toolchain/mips-linux-gnu
TOOLCHAIN_EXTERNAL_SOURCE = mips-2016.05-8-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_NIOSII),y)
TOOLCHAIN_EXTERNAL_SITE = http://sourcery.mentor.com/public/gnu_toolchain/nios2-linux-gnu
TOOLCHAIN_EXTERNAL_SOURCE = sourceryg++-2016.05-10-nios2-linux-gnu-i686-pc-linux-gnu.tar.bz2
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_SH),y)
TOOLCHAIN_EXTERNAL_SITE = https://sourcery.mentor.com/public/gnu_toolchain/sh-linux-gnu
TOOLCHAIN_EXTERNAL_SOURCE = renesas-2012.09-61-sh-linux-gnu-i686-pc-linux-gnu.tar.bz2
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_X86),y)
TOOLCHAIN_EXTERNAL_SITE = https://sourcery.mentor.com/public/gnu_toolchain/i686-pc-linux-gnu
TOOLCHAIN_EXTERNAL_SOURCE = ia32-2012.09-62-i686-pc-linux-gnu-i386-linux.tar.bz2
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_AMD64),y)
TOOLCHAIN_EXTERNAL_SITE = https://sourcery.mentor.com/public/gnu_toolchain/x86_64-amd-linux-gnu
TOOLCHAIN_EXTERNAL_SOURCE = amd-2015.11-139-x86_64-amd-linux-gnu-i686-pc-linux-gnu.tar.bz2
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESCAPE_IMG_MIPS),y)
TOOLCHAIN_EXTERNAL_SITE = http://codescape-mips-sdk.imgtec.com/components/toolchain/2016.05-03
TOOLCHAIN_EXTERNAL_SOURCE = Codescape.GNU.Tools.Package.2016.05-03.for.MIPS.IMG.Linux.CentOS-5.x86.tar.gz
TOOLCHAIN_EXTERNAL_POST_INSTALL_STAGING_HOOKS += TOOLCHAIN_EXTERNAL_CODESCAPE_MIPS_SYMLINK
TOOLCHAIN_EXTERNAL_POST_INSTALL_STAGING_HOOKS += TOOLCHAIN_EXTERNAL_CODESCAPE_MIPS_STAGING_FIXUPS
TOOLCHAIN_EXTERNAL_STRIP_COMPONENTS = 2
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS),y)
TOOLCHAIN_EXTERNAL_SITE = http://codescape-mips-sdk.imgtec.com/components/toolchain/2016.05-03
TOOLCHAIN_EXTERNAL_SOURCE = Codescape.GNU.Tools.Package.2016.05-03.for.MIPS.MTI.Linux.CentOS-5.x86.tar.gz
TOOLCHAIN_EXTERNAL_POST_INSTALL_STAGING_HOOKS += TOOLCHAIN_EXTERNAL_CODESCAPE_MIPS_SYMLINK
TOOLCHAIN_EXTERNAL_POST_INSTALL_STAGING_HOOKS += TOOLCHAIN_EXTERNAL_CODESCAPE_MIPS_STAGING_FIXUPS
TOOLCHAIN_EXTERNAL_STRIP_COMPONENTS = 2
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX),y)
TOOLCHAIN_EXTERNAL_SITE = http://downloads.sourceforge.net/project/adi-toolchain/2014R1/2014R1-RC2/i386
TOOLCHAIN_EXTERNAL_SOURCE = blackfin-toolchain-2014R1-RC2.i386.tar.bz2
TOOLCHAIN_EXTERNAL_EXTRA_DOWNLOADS = blackfin-toolchain-uclibc-full-2014R1-RC2.i386.tar.bz2
TOOLCHAIN_EXTERNAL_STRIP_COMPONENTS = 3
TOOLCHAIN_EXTERNAL_POST_EXTRACT_HOOKS += TOOLCHAIN_EXTERNAL_BLACKFIN_UCLIBC_EXTRA_EXTRACT
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_AARCH64),y)
TOOLCHAIN_EXTERNAL_SITE = http://sourcery.mentor.com/public/gnu_toolchain/aarch64-amd-linux-gnu
TOOLCHAIN_EXTERNAL_SOURCE = aarch64-amd-2014.11-95-aarch64-amd-linux-gnu-i686-pc-linux-gnu.tar.bz2
define TOOLCHAIN_EXTERNAL_CODESOURCERY_AARCH64_STAGING_FIXUP
	ln -sf ld-2.20.so $(STAGING_DIR)/lib/ld-linux-aarch64.so.1
endef
TOOLCHAIN_EXTERNAL_POST_INSTALL_STAGING_HOOKS += TOOLCHAIN_EXTERNAL_CODESOURCERY_AARCH64_STAGING_FIXUP
define TOOLCHAIN_EXTERNAL_CODESOURCERY_AARCH64_TARGET_FIXUP
	ln -sf ld-2.20.so $(TARGET_DIR)/lib/ld-linux-aarch64.so.1
endef
TOOLCHAIN_EXTERNAL_POST_INSTALL_TARGET_HOOKS += TOOLCHAIN_EXTERNAL_CODESOURCERY_AARCH64_TARGET_FIXUP
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_MUSL_CROSS),y)
TOOLCHAIN_EXTERNAL_VERSION = 1.1.12
TOOLCHAIN_EXTERNAL_SITE = https://googledrive.com/host/0BwnS5DMB0YQ6bDhPZkpOYVFhbk0/musl-$(TOOLCHAIN_EXTERNAL_VERSION)
ifeq ($(BR2_arm)$(BR2_ARM_EABI),yy)
TOOLCHAIN_EXTERNAL_SOURCE = crossx86-arm-linux-musleabi-$(TOOLCHAIN_EXTERNAL_VERSION).tar.xz
else ifeq ($(BR2_arm)$(BR2_ARM_EABIHF),yy)
TOOLCHAIN_EXTERNAL_SOURCE = crossx86-arm-linux-musleabihf-$(TOOLCHAIN_EXTERNAL_VERSION).tar.xz
else ifeq ($(BR2_armeb),y)
TOOLCHAIN_EXTERNAL_SOURCE = crossx86-armeb-linux-musleabi-$(TOOLCHAIN_EXTERNAL_VERSION).tar.xz
else ifeq ($(BR2_i386),y)
TOOLCHAIN_EXTERNAL_SOURCE = crossx86-i486-linux-musl-$(TOOLCHAIN_EXTERNAL_VERSION).tar.xz
else ifeq ($(BR2_mips),y)
TOOLCHAIN_EXTERNAL_SOURCE = crossx86-mips-linux-musl-$(TOOLCHAIN_EXTERNAL_VERSION).tar.xz
else ifeq ($(BR2_mipsel):$(BR2_SOFT_FLOAT),y:)
TOOLCHAIN_EXTERNAL_SOURCE = crossx86-mipsel-linux-musl-$(TOOLCHAIN_EXTERNAL_VERSION).tar.xz
else ifeq ($(BR2_mipsel):$(BR2_SOFT_FLOAT),y:y)
TOOLCHAIN_EXTERNAL_SOURCE = crossx86-mipsel-sf-linux-musl-$(TOOLCHAIN_EXTERNAL_VERSION).tar.xz
else ifeq ($(BR2_powerpc),y)
TOOLCHAIN_EXTERNAL_SOURCE = crossx86-powerpc-linux-musl-$(TOOLCHAIN_EXTERNAL_VERSION).tar.xz
else ifeq ($(BR2_sh4),y)
TOOLCHAIN_EXTERNAL_SOURCE = crossx86-sh4-linux-musl-$(TOOLCHAIN_EXTERNAL_VERSION).tar.xz
else ifeq ($(BR2_sh4eb),y)
TOOLCHAIN_EXTERNAL_SOURCE = crossx86-sh4eb-linux-musl-$(TOOLCHAIN_EXTERNAL_VERSION).tar.xz
else ifeq ($(BR2_x86_64),y)
TOOLCHAIN_EXTERNAL_SOURCE = crossx86-x86_64-linux-musl-$(TOOLCHAIN_EXTERNAL_VERSION).tar.xz
endif
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_SYNOPSYS_ARC),y)
TOOLCHAIN_EXTERNAL_SITE = https://github.com/foss-for-synopsys-dwc-arc-processors/toolchain/releases/download/arc-2014.12
ifeq ($(BR2_arc750d)$(BR2_arc770d),y)
TOOLCHAIN_EXTERNAL_SYNOPSYS_CORE = arc700
else
TOOLCHAIN_EXTERNAL_SYNOPSYS_CORE = archs
endif
ifeq ($(BR2_arcle),y)
TOOLCHAIN_EXTERNAL_SYNOPSYS_ENDIANESS = le
else
TOOLCHAIN_EXTERNAL_SYNOPSYS_ENDIANESS = be
endif
TOOLCHAIN_EXTERNAL_SOURCE = arc_gnu_2014.12_prebuilt_uclibc_$(TOOLCHAIN_EXTERNAL_SYNOPSYS_ENDIANESS)_$(TOOLCHAIN_EXTERNAL_SYNOPSYS_CORE)_linux_install.tar.gz
else
# Custom toolchain
TOOLCHAIN_EXTERNAL_SITE = $(patsubst %/,%,$(dir $(call qstrip,$(BR2_TOOLCHAIN_EXTERNAL_URL))))
TOOLCHAIN_EXTERNAL_SOURCE = $(notdir $(call qstrip,$(BR2_TOOLCHAIN_EXTERNAL_URL)))
# We can't check hashes for custom downloaded toolchains
BR_NO_CHECK_HASH_FOR += $(TOOLCHAIN_EXTERNAL_SOURCE)
endif

# Some toolchain vendors have a regular file naming pattern.
# For them, mass-define _ACTUAL_SOURCE_TARBALL based _SITE.
ifneq ($(findstring sourcery.mentor.com/public/gnu_toolchain,$(TOOLCHAIN_EXTERNAL_SITE)),)
TOOLCHAIN_EXTERNAL_ACTUAL_SOURCE_TARBALL ?= \
	$(subst -i686-pc-linux-gnu.tar.bz2,.src.tar.bz2,$(subst -i686-pc-linux-gnu-i386-linux.tar.bz2,-i686-pc-linux-gnu.src.tar.bz2,$(TOOLCHAIN_EXTERNAL_SOURCE)))
endif

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD),y)
TOOLCHAIN_EXTERNAL_EXCLUDES = usr/lib/locale/*

TOOLCHAIN_EXTERNAL_POST_EXTRACT_HOOKS += \
	TOOLCHAIN_EXTERNAL_MOVE
endif

# Checks for an already installed toolchain: check the toolchain
# location, check that it is usable, and then verify that it
# matches the configuration provided in Buildroot: ABI, C++ support,
# kernel headers version, type of C library and all C library features.
define TOOLCHAIN_EXTERNAL_CONFIGURE_CMDS
	$(Q)$(call check_cross_compiler_exists,$(TOOLCHAIN_EXTERNAL_CC))
	$(Q)$(call check_unusable_toolchain,$(TOOLCHAIN_EXTERNAL_CC))
	$(Q)SYSROOT_DIR="$(call toolchain_find_sysroot,$(TOOLCHAIN_EXTERNAL_CC))" ; \
	$(call check_kernel_headers_version,\
		$(call toolchain_find_sysroot,$(TOOLCHAIN_EXTERNAL_CC)),\
		$(call qstrip,$(BR2_TOOLCHAIN_HEADERS_AT_LEAST))); \
	$(call check_gcc_version,$(TOOLCHAIN_EXTERNAL_CC),\
		$(call qstrip,$(BR2_TOOLCHAIN_GCC_AT_LEAST))); \
	if test "$(BR2_arm)" = "y" ; then \
		$(call check_arm_abi,\
			"$(TOOLCHAIN_EXTERNAL_CC) $(TOOLCHAIN_EXTERNAL_CFLAGS)",\
			$(TOOLCHAIN_EXTERNAL_READELF)) ; \
	fi ; \
	if test "$(BR2_INSTALL_LIBSTDCPP)" = "y" ; then \
		$(call check_cplusplus,$(TOOLCHAIN_EXTERNAL_CXX)) ; \
	fi ; \
	if test "$(BR2_TOOLCHAIN_HAS_FORTRAN)" = "y" ; then \
		$(call check_fortran,$(TOOLCHAIN_EXTERNAL_FC)) ; \
	fi ; \
	if test "$(BR2_TOOLCHAIN_EXTERNAL_UCLIBC)" = "y" ; then \
		$(call check_uclibc,$${SYSROOT_DIR}) ; \
	elif test "$(BR2_TOOLCHAIN_EXTERNAL_MUSL)" = "y" ; then \
		$(call check_musl,$${SYSROOT_DIR}) ; \
	else \
		$(call check_glibc,$${SYSROOT_DIR}) ; \
	fi
	$(Q)$(call check_toolchain_ssp,$(TOOLCHAIN_EXTERNAL_CC))
endef

TOOLCHAIN_EXTERNAL_BUILD_CMDS = $(TOOLCHAIN_WRAPPER_BUILD)

define TOOLCHAIN_EXTERNAL_INSTALL_STAGING_CMDS
	$(TOOLCHAIN_WRAPPER_INSTALL)
	$(TOOLCHAIN_EXTERNAL_CREATE_STAGING_LIB_SYMLINK)
	$(TOOLCHAIN_EXTERNAL_INSTALL_SYSROOT_LIBS)
	$(TOOLCHAIN_EXTERNAL_INSTALL_SYSROOT_LIBS_BFIN_FDPIC)
	$(TOOLCHAIN_EXTERNAL_INSTALL_WRAPPER)
	$(TOOLCHAIN_EXTERNAL_INSTALL_GDBINIT)
endef

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_MUSL),y)
TOOLCHAIN_EXTERNAL_POST_INSTALL_STAGING_HOOKS += TOOLCHAIN_EXTERNAL_MUSL_LD_LINK
endif

# Even though we're installing things in both the staging, the host
# and the target directory, we do everything within the
# install-staging step, arbitrarily.
define TOOLCHAIN_EXTERNAL_INSTALL_TARGET_CMDS
	$(TOOLCHAIN_EXTERNAL_CREATE_TARGET_LIB_SYMLINK)
	$(TOOLCHAIN_EXTERNAL_INSTALL_TARGET_LIBS)
	$(TOOLCHAIN_EXTERNAL_INSTALL_TARGET_GDBSERVER)
	$(TOOLCHAIN_EXTERNAL_INSTALL_TARGET_BFIN_FDPIC)
	$(TOOLCHAIN_EXTERNAL_INSTALL_TARGET_BFIN_FLAT)
	$(TOOLCHAIN_EXTERNAL_FIXUP_UCLIBCNG_LDSO)
endef

endif # BR2_PACKAGE_PROVIDES_TOOLCHAIN_EXTERNAL


# Since a virtual package is just a generic package, we can still
# define commands for the legacy toolchains.
$(eval $(virtual-package))

# Ensure the external-toolchain package has a prefix defined.
# This comes after the virtual-package definition, which checks the provider.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL),y)
ifeq ($(call qstrip,$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)),)
$(error No prefix selected for external toolchain package $(BR2_PACKAGE_PROVIDES_TOOLCHAIN_EXTERNAL). Configuration error)
endif
endif

include toolchain/toolchain-external/*/*.mk
