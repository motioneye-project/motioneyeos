################################################################################
#
# nano
#
################################################################################

NANO_VERSION = 2.5.3
NANO_SITE = $(BR2_GNU_MIRROR)/nano
NANO_LICENSE = GPLv3+
NANO_LICENSE_FILES = COPYING
NANO_CONF_OPTS = \
	--without-slang \
	--with-wordbounds
NANO_DEPENDENCIES = ncurses

ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
NANO_CONF_ENV += ac_cv_prog_NCURSESW_CONFIG=$(STAGING_DIR)/usr/bin/$(NCURSES_CONFIG_SCRIPTS)
else
NANO_CONF_ENV += ac_cv_prog_NCURSESW_CONFIG=false
NANO_MAKE_ENV += CURSES_LIB="-lncurses"
endif

ifeq ($(BR2_PACKAGE_FILE),y)
NANO_DEPENDENCIES += file
else
NANO_CONF_ENV += ac_cv_lib_magic_magic_open=no
endif

ifeq ($(BR2_PACKAGE_NANO_TINY),y)
NANO_CONF_OPTS += --enable-tiny
define NANO_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/src/nano $(TARGET_DIR)/usr/bin/nano
endef
endif

$(eval $(autotools-package))
