################################################################################
#
# lcdproc
#
################################################################################

LCDPROC_VERSION = 0.5.9
LCDPROC_SITE = https://github.com/lcdproc/lcdproc/releases/download/v$(LCDPROC_VERSION)
LCDPROC_LICENSE = GPL-2.0+
LCDPROC_LICENSE_FILES = COPYING
LCDPROC_MAKE = $(MAKE1)

LCDPROC_CONF_OPTS = --enable-drivers=$(BR2_PACKAGE_LCDPROC_DRIVERS)

ifeq ($(BR2_PACKAGE_LCDPROC_MENUS),y)
LCDPROC_CONF_OPTS += --enable-lcdproc-menus
endif

LCDPROC_DEPENDENCIES = freetype ncurses zlib

LCDPROC_CONF_ENV += ac_cv_path_FT2_CONFIG=$(STAGING_DIR)/usr/bin/freetype-config

ifeq ($(BR2_PACKAGE_LIBPNG),y)
LCDPROC_DEPENDENCIES += libpng
LCDPROC_CONF_ENV += ac_cv_path__png_config=$(STAGING_DIR)/usr/bin/libpng-config
LCDPROC_CONF_OPTS += --enable-libpng
else
LCDPROC_CONF_OPTS += --disable-libpng
endif

$(eval $(autotools-package))
