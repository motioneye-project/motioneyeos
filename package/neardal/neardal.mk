################################################################################
#
# neardal
#
################################################################################

NEARDAL_VERSION = da8e06d3884d214bb19b894d2b8fdc9c7ca8575f
NEARDAL_SITE = $(call github,connectivity,neardal,$(NEARDAL_VERSION))
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
