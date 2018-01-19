################################################################################
#
# screen
#
################################################################################

SCREEN_VERSION = 4.6.2
SCREEN_SITE = $(BR2_GNU_MIRROR)/screen
SCREEN_LICENSE = GPL-3.0+
SCREEN_LICENSE_FILES = COPYING
SCREEN_DEPENDENCIES = ncurses
SCREEN_AUTORECONF = YES
SCREEN_CONF_ENV = CFLAGS="$(TARGET_CFLAGS)"
SCREEN_CONF_OPTS = --enable-colors256
SCREEN_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) SCREEN=screen install_bin

define SCREEN_INSTALL_SCREENRC
	$(INSTALL) -m 0755 -D $(@D)/etc/screenrc $(TARGET_DIR)/etc/screenrc
endef
SCREEN_POST_INSTALL_TARGET_HOOKS += SCREEN_INSTALL_SCREENRC

# Add /usr/bin/screen to /etc/shells otherwise some login tools like dropbear
# can reject the user connection. See man shells.
define SCREEN_ADD_SCREEN_TO_SHELLS
	grep -qsE '^/usr/bin/screen$$' $(TARGET_DIR)/etc/shells \
		|| echo "/usr/bin/screen" >> $(TARGET_DIR)/etc/shells
endef
SCREEN_TARGET_FINALIZE_HOOKS += SCREEN_ADD_SCREEN_TO_SHELLS

$(eval $(autotools-package))
