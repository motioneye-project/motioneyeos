################################################################################
#
# libidn2
#
################################################################################

LIBIDN2_VERSION = 2.0.5
LIBIDN2_SITE = $(BR2_GNU_MIRROR)/libidn
LIBIDN2_LICENSE := GPL-2.0+ or LGPL-3.0+ (library)
LIBIDN2_LICENSE_FILES = COPYING COPYINGv2 COPYING.LESSERv3 COPYING.unicode
LIBIDN2_DEPENDENCIES = \
	host-pkgconf \
	$(TARGET_NLS_DEPENDENCIES) \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)
LIBIDN2_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_LIBUNISTRING),y)
LIBIDN2_DEPENDENCIES += libunistring
endif

ifeq ($(BR2_PACKAGE_LIBIDN2_BINARY),)
define LIBIDN2_REMOVE_BINARY
	rm -f $(TARGET_DIR)/usr/bin/idn2
endef
LIBIDN2_POST_INSTALL_TARGET_HOOKS += LIBIDN2_REMOVE_BINARY
else
LIBIDN2_LICENSE := $(LIBIDN2_LICENSE), GPL-3.0+ (program)
endif

$(eval $(autotools-package))
