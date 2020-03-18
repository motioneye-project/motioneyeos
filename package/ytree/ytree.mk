################################################################################
#
# ytree
#
################################################################################

YTREE_VERSION = 2.02
YTREE_SITE = https://www.han.de/~werner
YTREE_LICENSE = GPL-2.0+
YTREE_LICENSE_FILES = COPYING
YTREE_DEPENDENCIES = ncurses

YTREE_CFLAGS = -DCOLOR_SUPPORT $(TARGET_CFLAGS)
YTREE_LDFLAGS = -lncurses $(TARGET_LDFLAGS)

ifeq ($(BR2_PACKAGE_READLINE),y)
YTREE_DEPENDENCIES += host-pkgconf readline
YTREE_CFLAGS += -DREADLINE_SUPPORT
YTREE_LDFLAGS += `$(PKG_CONFIG_HOST_BINARY) --libs readline`
endif

define YTREE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(YTREE_CFLAGS)" LDFLAGS="$(YTREE_LDFLAGS)"
endef

define YTREE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)/usr" install
endef

$(eval $(generic-package))
