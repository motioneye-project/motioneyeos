################################################################################
#
# neardal
#
################################################################################

NEARDAL_VERSION = 4143d130ed39299bfc59d08d2c7c77dbc7f809e9
NEARDAL_SITE = $(call github,connectivity,neardal,$(NEARDAL_VERSION))
NEARDAL_INSTALL_STAGING = YES
NEARDAL_LICENSE = LGPL-2.0
NEARDAL_LICENSE_FILES = COPYING

NEARDAL_DEPENDENCIES = host-pkgconf dbus dbus-glib libedit
NEARDAL_AUTORECONF = YES

define NEARDAL_INSTALL_NCL
	$(INSTALL) -m 0755 -D $(@D)/ncl/ncl $(TARGET_DIR)/usr/bin/ncl
endef

ifeq ($(BR2_PACKAGE_NEARDAL_NCL),y)
NEARDAL_POST_INSTALL_TARGET_HOOKS += NEARDAL_INSTALL_NCL
endif

$(eval $(autotools-package))
