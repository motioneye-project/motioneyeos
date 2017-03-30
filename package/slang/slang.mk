################################################################################
#
# slang
#
################################################################################

SLANG_VERSION = 2.3.0
SLANG_SITE = http://www.jedsoft.org/releases/slang
SLANG_LICENSE = GPL-2.0+
SLANG_LICENSE_FILES = COPYING
SLANG_INSTALL_STAGING = YES
SLANG_CONF_OPTS = --with-onig=no
SLANG_MAKE = $(MAKE1)

# Racy and we don't have/do libtermcap
define SLANG_DISABLE_TERMCAP
	$(SED) '/^TERMCAP=/s:=.*:=:' $(@D)/configure
endef
SLANG_POST_PATCH_HOOKS += SLANG_DISABLE_TERMCAP

# Absolute path hell, sigh...
ifeq ($(BR2_PACKAGE_LIBPNG),y)
SLANG_CONF_OPTS += --with-png=$(STAGING_DIR)/usr
SLANG_DEPENDENCIES += libpng
else
SLANG_CONF_OPTS += --with-png=no
endif
ifeq ($(BR2_PACKAGE_PCRE),y)
SLANG_CONF_OPTS += --with-pcre=$(STAGING_DIR)/usr
SLANG_DEPENDENCIES += pcre
else
SLANG_CONF_OPTS += --with-pcre=no
endif
ifeq ($(BR2_PACKAGE_ZLIB),y)
SLANG_CONF_OPTS += --with-z=$(STAGING_DIR)/usr
SLANG_DEPENDENCIES += zlib
else
SLANG_CONF_OPTS += --with-z=no
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
SLANG_DEPENDENCIES += ncurses
SLANG_CONF_ENV += ac_cv_path_nc5config=$(STAGING_DIR)/usr/bin/$(NCURSES_CONFIG_SCRIPTS)
else
SLANG_CONF_OPTS += ac_cv_path_nc5config=no
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
SLANG_CONF_OPTS += --with-readline=gnu
SLANG_DEPENDENCIES += readline
ifeq ($(BR2_STATIC_LIBS),y)
SLANG_CONF_ENV += LIBS="`$(STAGING_DIR)/usr/bin/$(NCURSES_CONFIG_SCRIPTS) --libs`"
endif
endif

ifeq ($(BR2_STATIC_LIBS),y)
SLANG_MAKE_OPTS = static
SLANG_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) install-static
SLANG_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) install-static
endif

$(eval $(autotools-package))
