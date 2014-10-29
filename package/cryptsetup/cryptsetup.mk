################################################################################
#
# cryptsetup
#
################################################################################

CRYPTSETUP_VERSION_MAJOR = 1.6
CRYPTSETUP_VERSION = $(CRYPTSETUP_VERSION_MAJOR).6
CRYPTSETUP_SOURCE = cryptsetup-$(CRYPTSETUP_VERSION).tar.xz
CRYPTSETUP_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/cryptsetup/v$(CRYPTSETUP_VERSION_MAJOR)
CRYPTSETUP_CONF_ENV += LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config
CRYPTSETUP_DEPENDENCIES = lvm2 popt e2fsprogs libgcrypt host-pkgconf \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)
CRYPTSETUP_LICENSE = GPLv2+ (programs), LGPLv2.1+ (library)
CRYPTSETUP_LICENSE_FILES = COPYING COPYING.LGPL

CRYPTSETUP_AUTORECONF = YES

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
CRYPTSETUP_CONF_ENV += LDFLAGS="$(TARGET_LDFLAGS) -lintl"
endif

$(eval $(autotools-package))
