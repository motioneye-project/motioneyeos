################################################################################
#
# neardal
#
################################################################################

NEARDAL_VERSION = 33b54a55032b047fd885a5eb3592c169c0056c49
NEARDAL_SITE = $(call github,connectivity,neardal,$(NEARDAL_VERSION))
NEARDAL_INSTALL_STAGING = YES
NEARDAL_LICENSE = GPLv2
NEARDAL_LICENSE_FILES = COPYING

NEARDAL_DEPENDENCIES = host-pkgconf dbus dbus-glib
NEARDAL_AUTORECONF = YES

# Either readline or libedit are needed, and the Config.in file
# guarantees at least one of them is enabled
ifeq ($(BR2_PACKAGE_READLINE),y)
NEARDAL_DEPENDENCIES += readline
else ifeq ($(BR2_PACKAGE_LIBEDIT),y)
NEARDAL_DEPENDENCIES += libedit
endif

# Both readline and libedit link with ncurses but the configure script
# forgets to take that into account, causing the detection to fail
# when linking statically
ifeq ($(BR2_STATIC_LIBS),y)
NEARDAL_CONF_ENV += LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs ncurses`"
endif

define NEARDAL_INSTALL_NCL
	$(INSTALL) -m 0755 -D $(@D)/ncl/ncl $(TARGET_DIR)/usr/bin/ncl
endef

ifeq ($(BR2_PACKAGE_NEARDAL_NCL),y)
NEARDAL_POST_INSTALL_TARGET_HOOKS += NEARDAL_INSTALL_NCL
endif

$(eval $(autotools-package))
