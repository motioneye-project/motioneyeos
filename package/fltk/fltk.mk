################################################################################
#
# fltk
#
################################################################################

FLTK_VERSION = 1.3.5
FLTK_SOURCE = fltk-$(FLTK_VERSION)-source.tar.gz
FLTK_SITE = http://fltk.org/pub/fltk/$(FLTK_VERSION)
FLTK_INSTALL_STAGING = YES
# We force --libdir=/usr/lib, because by default, it is set to
# ${exec_prefix}/lib, which doesn't match the condition used by the
# fltk build system to decide whether it should pass a -rpath,/usr/lib
# or not. Since this rpath breaks the build, we want the fltk build
# system to not pass it, which requires having --libdir set to
# /usr/lib.
FLTK_CONF_OPTS = --enable-threads --with-x --disable-gl \
	--disable-localjpeg --disable-localpng --disable-localzlib \
	--libdir=/usr/lib
FLTK_DEPENDENCIES = jpeg libpng xlib_libX11 xlib_libXext xlib_libXt
FLTK_CONFIG_SCRIPTS = fltk-config
FLTK_LICENSE = LGPL-2.0 with exceptions
FLTK_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_CAIRO),y)
FLTK_CONF_OPTS += --enable-cairo
FLTK_DEPENDENCIES += cairo
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCURSOR),y)
FLTK_DEPENDENCIES += xlib_libXcursor
FLTK_CONF_OPTS += --enable-xcursor
else
FLTK_CONF_OPTS += --disable-xcursor
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFIXES),y)
FLTK_DEPENDENCIES += xlib_libXfixes
FLTK_CONF_OPTS += --enable-xfixes
else
FLTK_CONF_OPTS += --disable-xfixes
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

ifeq ($(BR2_PACKAGE_XLIB_LIBXRENDER),y)
FLTK_DEPENDENCIES += xlib_libXrender
FLTK_CONF_OPTS += --enable-xrender
else
FLTK_CONF_OPTS += --disable-xrender
endif

$(eval $(autotools-package))
