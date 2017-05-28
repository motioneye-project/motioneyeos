################################################################################
#
# dvdauthor
#
################################################################################

DVDAUTHOR_VERSION = 0.7.2
DVDAUTHOR_SITE = https://sourceforge.net/projects/dvdauthor/files
DVDAUTHOR_DEPENDENCIES = host-pkgconf libxml2 freetype libpng
DVDAUTHOR_LICENSE = GPL-2.0+
DVDAUTHOR_LICENSE_FILES = COPYING
DVDAUTHOR_CONF_ENV = \
	ac_cv_prog_FREETYPECONFIG=$(STAGING_DIR)/usr/bin/freetype-config \
	ac_cv_path_XML2_CONFIG=$(STAGING_DIR)/usr/bin/xml2-config \
	ac_cv_prog_GMAGICKCONFIG=

ifeq ($(BR2_PACKAGE_IMAGEMAGICK),y)
DVDAUTHOR_DEPENDENCIES += imagemagick
DVDAUTHOR_CONF_ENV += \
	ac_cv_prog_MAGICKCONFIG=$(STAGING_DIR)/usr/bin/Magick-config
else
DVDAUTHOR_CONF_ENV += \
	ac_cv_prog_MAGICKCONFIG=
endif

# Automatically detected by dvdauthor configure script, no way to
# disable.
ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
DVDAUTHOR_DEPENDENCIES += fontconfig
endif

ifeq ($(BR2_PACKAGE_LIBFRIBIDI),y)
DVDAUTHOR_DEPENDENCIES += libfribidi
endif

ifeq ($(BR2_PACKAGE_DVDAUTHOR_DVDUNAUTHOR),y)
DVDAUTHOR_DEPENDENCIES += libdvdread
# dvdauthor configure does not use pkg-config to detect libdvdread
ifeq ($(BR2_PACKAGE_LIBDVDCSS)$(BR2_STATIC_LIBS),yy)
DVDAUTHOR_CONF_ENV += LIBS="-ldvdcss"
endif
DVDAUTHOR_CONF_OPTS += --enable-dvdunauthor
else
DVDAUTHOR_CONF_OPTS += --disable-dvdunauthor
endif

$(eval $(autotools-package))
