################################################################################
#
# dialog
#
################################################################################

DIALOG_VERSION = 1.1-20111020
DIALOG_SOURCE = dialog-$(DIALOG_VERSION).tgz
DIALOG_SITE = ftp://invisible-island.net/dialog
DIALOG_CONF_OPT = --with-ncurses
DIALOG_CONF_ENV = ac_cv_path_NCURSES_CONFIG=true LIBS=-lncurses
DIALOG_DEPENDENCIES = ncurses
DIALOG_LICENSE = LGPLv2.1
DIALOG_LICENSE_FILES = COPYING

ifneq ($(BR2_ENABLE_LOCALE),y)
DIALOG_DEPENDENCIES += libiconv
endif

define DIALOG_INSTALL_TARGET_CMDS
	install -c $(@D)/dialog $(TARGET_DIR)/usr/bin/dialog
endef

$(eval $(autotools-package))
