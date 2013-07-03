################################################################################
#
# kmod
#
################################################################################

KMOD_VERSION = 14
KMOD_SOURCE = kmod-$(KMOD_VERSION).tar.xz
KMOD_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/kernel/kmod/
KMOD_INSTALL_STAGING = YES
KMOD_DEPENDENCIES = host-pkgconf

# license info for libkmod only, conditionally add more below
KMOD_LICENSE = LGPLv2.1+
KMOD_LICENSE_FILES = libkmod/COPYING

# static linking not supported, see
# https://git.kernel.org/cgit/utils/kernel/kmod/kmod.git/commit/?id=b7016153ec8
KMOD_CONF_OPT = --disable-static --enable-shared

ifneq ($(BR2_HAVE_DOCUMENTATION),y)
KMOD_CONF_OPT += --disable-manpages
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
KMOD_DEPENDENCIES += zlib
KMOD_CONF_OPT += --with-zlib
endif

ifeq ($(BR2_PACKAGE_XZ),y)
KMOD_DEPENDENCIES += xz
KMOD_CONF_OPT += --with-xz
endif

ifeq ($(BR2_PACKAGE_KMOD_TOOLS),y)

# add license info for kmod tools
KMOD_LICENSE += GPLv2+
KMOD_LICENSE_FILES += COPYING

# take precedence over busybox / module-init-tools implementations
KMOD_DEPENDENCIES += \
	$(if $(BR2_PACKAGE_BUSYBOX),busybox) \
	$(if $(BR2_PACKAGE_MODULE_INIT_TOOLS),module-init-tools)

define KMOD_INSTALL_TOOLS
	for i in depmod insmod lsmod modinfo modprobe rmmod; \
	do ln -sf ../usr/bin/kmod $(TARGET_DIR)/sbin/$$i; done
endef

KMOD_POST_INSTALL_TARGET_HOOKS += KMOD_INSTALL_TOOLS
else
KMOD_CONF_OPT += --disable-tools
endif

$(eval $(autotools-package))
