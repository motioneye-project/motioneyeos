################################################################################
#
# syslinux to make target msdos/iso9660 filesystems bootable
#
################################################################################

SYSLINUX_VERSION = 4.07
SYSLINUX_SOURCE  = syslinux-$(SYSLINUX_VERSION).tar.bz2
SYSLINUX_SITE    = $(BR2_KERNEL_MIRROR)/linux/utils/boot/syslinux/4.xx/

SYSLINUX_LICENSE = GPLv2+
SYSLINUX_LICENSE_FILES = COPYING

SYSLINUX_INSTALL_IMAGES = YES

SYSLINUX_DEPENDENCIES = host-nasm host-util-linux

# syslinux build system has no convenient way to pass CFLAGS,
# and the internal zlib should take precedence so -I shouldn't
# be used.
define SYSLINUX_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(HOSTCC) -idirafter $(HOST_DIR)/usr/include $(HOST_LDFLAGS)" AR="$(HOSTAR)" -C $(@D)
endef

define SYSLINUX_INSTALL_TARGET_CMDS
	# While the actual bootloader is compiled for the target, several
	# utilities for installing the bootloader are meant for the host.
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) INSTALLROOT=$(HOST_DIR) install
endef

SYSLINUX_IMAGES-$(BR2_TARGET_SYSLINUX_ISOLINUX) += core/isolinux.bin
SYSLINUX_IMAGES-$(BR2_TARGET_SYSLINUX_PXELINUX) += core/pxelinux.bin

define SYSLINUX_INSTALL_IMAGES_CMDS
	for i in $(SYSLINUX_IMAGES-y); do \
		$(INSTALL) -D -m 0755 $(@D)/$$i $(BINARIES_DIR)/$${i##*/}; \
	done
endef

$(eval $(generic-package))
