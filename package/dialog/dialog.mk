################################################################################
#
# dialog
#
################################################################################

DIALOG_VERSION = 1.3-20191210
DIALOG_SOURCE = dialog-$(DIALOG_VERSION).tgz
DIALOG_SITE = https://invisible-mirror.net/archives/dialog
DIALOG_CONF_OPTS = --with-ncurses --with-curses-dir=$(STAGING_DIR)/usr \
	--disable-rpath-hack
DIALOG_DEPENDENCIES = host-pkgconf ncurses $(TARGET_NLS_DEPENDENCIES)
DIALOG_LICENSE = LGPL-2.1
DIALOG_LICENSE_FILES = COPYING

ifneq ($(BR2_ENABLE_LOCALE),y)
DIALOG_DEPENDENCIES += libiconv
endif

DIALOG_CONF_OPTS += NCURSES_CONFIG=$(STAGING_DIR)/usr/bin/$(NCURSES_CONFIG_SCRIPTS)

$(eval $(autotools-package))
