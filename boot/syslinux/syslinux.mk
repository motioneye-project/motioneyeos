################################################################################
#
# syslinux to make target msdos/iso9660 filesystems bootable
#
################################################################################

SYSLINUX_VERSION = 6.03
SYSLINUX_SOURCE = syslinux-$(SYSLINUX_VERSION).tar.xz
SYSLINUX_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/boot/syslinux

SYSLINUX_LICENSE = GPL-2.0+
SYSLINUX_LICENSE_FILES = COPYING

SYSLINUX_INSTALL_IMAGES = YES

# host-util-linux needed to provide libuuid when building host tools
SYSLINUX_DEPENDENCIES = host-nasm host-upx util-linux host-util-linux

ifeq ($(BR2_TARGET_SYSLINUX_LEGACY_BIOS),y)
SYSLINUX_TARGET += bios
endif

# The syslinux build system must be forced to use Buildroot's gnu-efi
# package by setting EFIINC, LIBDIR and LIBEFI. Otherwise, it uses its
# own copy of gnu-efi included in syslinux's sources since 6.03
# release.
ifeq ($(BR2_TARGET_SYSLINUX_EFI),y)
ifeq ($(BR2_ARCH_IS_64),y)
SYSLINUX_EFI_BITS = efi64
else
SYSLINUX_EFI_BITS = efi32
endif # 64-bit
SYSLINUX_DEPENDENCIES += gnu-efi
SYSLINUX_TARGET += $(SYSLINUX_EFI_BITS)
SYSLINUX_EFI_ARGS = \
	EFIINC=$(STAGING_DIR)/usr/include/efi \
	LIBDIR=$(STAGING_DIR)/usr/lib \
	LIBEFI=$(STAGING_DIR)/usr/lib/libefi.a
endif # EFI

# The syslinux tarball comes with pre-compiled binaries.
# Since timestamps might not be in the correct order, a rebuild is
# not always triggered for all the different images.
# Cleanup the mess even before we attempt a build, so we indeed
# build everything from source.
define SYSLINUX_CLEANUP
	rm -rf $(@D)/bios $(@D)/efi32 $(@D)/efi64
endef
SYSLINUX_POST_PATCH_HOOKS += SYSLINUX_CLEANUP

# syslinux build system has no convenient way to pass CFLAGS,
# and the internal zlib should take precedence so -I shouldn't
# be used.
define SYSLINUX_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) \
		CC="$(TARGET_CC)" \
		LD="$(TARGET_LD)" \
		NASM="$(HOST_DIR)/bin/nasm" \
		CC_FOR_BUILD="$(HOSTCC)" \
		CFLAGS_FOR_BUILD="$(HOST_CFLAGS)" \
		LDFLAGS_FOR_BUILD="$(HOST_LDFLAGS)" \
		$(SYSLINUX_EFI_ARGS) -C $(@D) $(SYSLINUX_TARGET)
endef

# While the actual bootloader is compiled for the target, several
# utilities for installing the bootloader are meant for the host.
# Repeat the target, otherwise syslinux will try to build everything
# Repeat LD (and CC) as it happens that some binaries are linked at
# install-time.
define SYSLINUX_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) $(SYSLINUX_EFI_ARGS) INSTALLROOT=$(HOST_DIR) \
		CC="$(TARGET_CC)" \
		LD="$(TARGET_LD)" \
		-C $(@D) $(SYSLINUX_TARGET) install
endef

# That 'syslinux' binary is an installer actually built for the target.
# However, buildroot makes no usage of it, so better delete it than have it
# installed at the wrong place
define SYSLINUX_POST_INSTALL_CLEANUP
	rm -rf $(HOST_DIR)/bin/syslinux
endef
SYSLINUX_POST_INSTALL_TARGET_HOOKS += SYSLINUX_POST_INSTALL_CLEANUP

SYSLINUX_IMAGES-$(BR2_TARGET_SYSLINUX_ISOLINUX) += bios/core/isolinux.bin
SYSLINUX_IMAGES-$(BR2_TARGET_SYSLINUX_PXELINUX) += bios/core/pxelinux.bin
SYSLINUX_IMAGES-$(BR2_TARGET_SYSLINUX_MBR) += bios/mbr/mbr.bin
SYSLINUX_IMAGES-$(BR2_TARGET_SYSLINUX_EFI) += $(SYSLINUX_EFI_BITS)/efi/syslinux.efi

SYSLINUX_C32 = $(call qstrip,$(BR2_TARGET_SYSLINUX_C32))

# We install the c32 modules from the host-installed tree, where they
# are all neatly installed in a single location, while they are
# scattered around everywhere in the build tree.
define SYSLINUX_INSTALL_IMAGES_CMDS
	for i in $(SYSLINUX_IMAGES-y); do \
		$(INSTALL) -D -m 0755 $(@D)/$$i $(BINARIES_DIR)/syslinux/$${i##*/}; \
	done
	for i in $(SYSLINUX_C32); do \
		$(INSTALL) -D -m 0755 $(HOST_DIR)/share/syslinux/$${i} \
			$(BINARIES_DIR)/syslinux/$${i}; \
	done
endef

$(eval $(generic-package))
