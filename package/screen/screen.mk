################################################################################
#
# screen
#
################################################################################

SCREEN_VERSION = 4.2.1
SCREEN_SITE = $(BR2_GNU_MIRROR)/screen
SCREEN_LICENSE = GPLv3+
SCREEN_LICENSE_FILES = COPYING
SCREEN_DEPENDENCIES = ncurses
SCREEN_AUTORECONF = YES
SCREEN_CONF_ENV = CFLAGS="$(TARGET_CFLAGS)"
SCREEN_MAKE = $(MAKE1)
SCREEN_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) SCREEN=screen install_bin

define SCREEN_INSTALL_SCREENRC
	$(INSTALL) -m 0755 -D $(@D)/etc/screenrc $(TARGET_DIR)/etc/screenrc
endef

SCREEN_POST_INSTALL_TARGET_HOOKS += SCREEN_INSTALL_SCREENRC

$(eval $(autotools-package))
