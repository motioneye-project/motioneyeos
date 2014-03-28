################################################################################
#
# slang
#
################################################################################

SLANG_VERSION_MAJOR = 2.2
SLANG_VERSION = $(SLANG_VERSION_MAJOR).4
SLANG_SOURCE = slang-$(SLANG_VERSION).tar.bz2
SLANG_SITE = ftp://ftp.fu-berlin.de/pub/unix/misc/slang/v$(SLANG_VERSION_MAJOR)/
SLANG_LICENSE = GPLv2+
SLANG_LICENSE_FILES = COPYING
SLANG_INSTALL_STAGING = YES
SLANG_MAKE = $(MAKE1)

# Absolute path hell, sigh...
ifeq ($(BR2_PACKAGE_LIBPNG),y)
	SLANG_CONF_OPT += --with-png=$(STAGING_DIR)/usr
	SLANG_DEPENDENCIES += libpng
else
	SLANG_CONF_OPT += --with-png=no
endif
ifeq ($(BR2_PACKAGE_PCRE),y)
	SLANG_CONF_OPT += --with-pcre=$(STAGING_DIR)/usr
	SLANG_DEPENDENCIES += pcre
else
	SLANG_CONF_OPT += --with-pcre=no
endif
ifeq ($(BR2_PACKAGE_ZLIB),y)
	SLANG_CONF_OPT += --with-z=$(STAGING_DIR)/usr
	SLANG_DEPENDENCIES += zlib
else
	SLANG_CONF_OPT += --with-z=no
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
	SLANG_DEPENDENCIES += ncurses
else
	SLANG_CONF_OPT += ac_cv_path_nc5config=no
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
	SLANG_CONF_OPT += --with-readline=gnu
	SLANG_DEPENDENCIES += readline
endif

$(eval $(autotools-package))
