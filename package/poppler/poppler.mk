################################################################################
#
# poppler
#
################################################################################

POPPLER_VERSION = 0.54.0
POPPLER_SOURCE = poppler-$(POPPLER_VERSION).tar.xz
POPPLER_SITE = http://poppler.freedesktop.org
POPPLER_DEPENDENCIES = fontconfig host-pkgconf
POPPLER_LICENSE = GPL-2.0+
POPPLER_LICENSE_FILES = COPYING
POPPLER_INSTALL_STAGING = YES
POPPLER_CONF_OPTS = --with-font-configuration=fontconfig \
	--enable-xpdf-headers

ifeq ($(BR2_PACKAGE_CAIRO),y)
POPPLER_CONF_OPTS += --enable-cairo-output
POPPLER_DEPENDENCIES += cairo
else
POPPLER_CONF_OPTS += --disable-cairo-output
endif

ifeq ($(BR2_PACKAGE_LCMS2),y)
POPPLER_CONF_OPTS += --enable-cms=lcms2
POPPLER_DEPENDENCIES += lcms2
else
POPPLER_CONF_OPTS += --enable-cms=none
endif

ifeq ($(BR2_PACKAGE_CAIRO)$(BR2_PACKAGE_LIBGLIB2),yy)
POPPLER_CONF_OPTS += --enable-poppler-glib
POPPLER_DEPENDENCIES += libglib2
else
POPPLER_CONF_OPTS += --disable-poppler-glib
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
POPPLER_CONF_OPTS += --enable-libtiff
# Help poppler to find libtiff in static linking scenarios
POPPLER_CONF_ENV += \
	LIBTIFF_LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs libtiff-4`"
POPPLER_DEPENDENCIES += tiff
else
POPPLER_CONF_OPTS += --disable-libtiff
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
POPPLER_CONF_OPTS += --enable-libjpeg
POPPLER_DEPENDENCIES += jpeg
else
POPPLER_CONF_OPTS += --disable-libjpeg
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
POPPLER_CONF_OPTS += --enable-libpng
POPPLER_DEPENDENCIES += libpng
else
POPPLER_CONF_OPTS += --disable-libpng
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
POPPLER_CONF_OPTS += --enable-zlib
POPPLER_DEPENDENCIES += zlib
else
POPPLER_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_POPPLER_LIBCURL),y)
POPPLER_CONF_OPTS += --enable-libcurl
POPPLER_DEPENDENCIES += libcurl
else
POPPLER_CONF_OPTS += --disable-libcurl
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
POPPLER_CONF_OPTS += --with-x
POPPLER_DEPENDENCIES += xlib_libX11 xlib_libXext
else
POPPLER_CONF_OPTS += --without-x
endif

ifeq ($(BR2_PACKAGE_POPPLER_QT),y)
POPPLER_DEPENDENCIES += qt
POPPLER_CONF_OPTS += --enable-poppler-qt4
else
POPPLER_CONF_OPTS += --disable-poppler-qt4
endif

ifeq ($(BR2_PACKAGE_POPPLER_QT5),y)
POPPLER_DEPENDENCIES += qt5base
POPPLER_CONF_OPTS += --enable-poppler-qt5
# since Qt5.7.x c++11 is needed (LTS Qt5.6.x is the last one without this requirement)
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
POPPLER_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) -std=c++11"
endif
else
POPPLER_CONF_OPTS += --disable-poppler-qt5
endif

ifeq ($(BR2_PACKAGE_OPENJPEG),y)
POPPLER_DEPENDENCIES += openjpeg
POPPLER_CONF_OPTS += --enable-libopenjpeg
else
POPPLER_CONF_OPTS += --enable-libopenjpeg=none
endif

$(eval $(autotools-package))
