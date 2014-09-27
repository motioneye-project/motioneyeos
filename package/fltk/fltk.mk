################################################################################
#
# fltk
#
################################################################################

FLTK_VERSION = 1.3.2
FLTK_SOURCE = fltk-$(FLTK_VERSION)-source.tar.gz
FLTK_SITE = http://fltk.org/pub/fltk/$(FLTK_VERSION)
FLTK_INSTALL_STAGING = YES
FLTK_CONF_OPTS = --enable-threads --with-x --disable-gl \
	--disable-localjpeg --disable-localpng --disable-localzlib
FLTK_DEPENDENCIES = jpeg libpng xlib_libX11 xlib_libXext xlib_libXt
FLTK_CONFIG_SCRIPTS = fltk-config
FLTK_LICENSE = LGPLv2 with exceptions
FLTK_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_CAIRO),y)
FLTK_CONF_OPTS += --enable-cairo
FLTK_DEPENDENCIES += cairo
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFT),y)
FLTK_CONF_ENV += ac_cv_path_FTCONFIG=$(STAGING_DIR)/usr/bin/freetype-config
FLTK_DEPENDENCIES += xlib_libXft
else
FLTK_CONF_OPTS += --disable-xft
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
FLTK_DEPENDENCIES += xlib_libXinerama
else
FLTK_CONF_OPTS += --disable-xinerama
endif

$(eval $(autotools-package))
