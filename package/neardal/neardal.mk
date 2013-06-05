################################################################################
#
# neardal
#
################################################################################

NEARDAL_VERSION = 0.8
NEARDAL_SITE = http://github.com/connectivity/neardal/tarball/$(NEARDAL_VERSION)
NEARDAL_SOURCE = connectivity-neardal-$(NEARDAL_VERSION).tar.gz
NEARDAL_INSTALL_STAGING = YES
NEARDAL_LICENSE = GPLv2
NEARDAL_LICENSE_FILES = COPYING

NEARDAL_DEPENDENCIES = host-pkgconf dbus dbus-glib
NEARDAL_AUTORECONF = YES

define NEARDAL_INSTALL_NCL
	$(INSTALL) -m 0755 -D $(@D)/ncl/ncl $(TARGET_DIR)/usr/bin/ncl
endef

ifeq ($(BR2_PACKAGE_NEARDAL_NCL),y)
	NEARDAL_POST_INSTALL_TARGET_HOOKS += NEARDAL_INSTALL_NCL
endif

$(eval $(autotools-package))
