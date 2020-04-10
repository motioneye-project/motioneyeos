################################################################################
#
# libbluray
#
################################################################################

LIBBLURAY_VERSION = 1.2.0
LIBBLURAY_SITE = http://download.videolan.org/pub/videolan/libbluray/$(LIBBLURAY_VERSION)
LIBBLURAY_SOURCE = libbluray-$(LIBBLURAY_VERSION).tar.bz2
LIBBLURAY_INSTALL_STAGING = YES
LIBBLURAY_LICENSE = LGPL-2.1+
LIBBLURAY_LICENSE_FILES = COPYING
LIBBLURAY_DEPENDENCIES = host-pkgconf

LIBBLURAY_CONF_OPTS = --disable-bdjava-jar

ifeq ($(BR2_PACKAGE_LIBICONV),y)
LIBBLURAY_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
LIBBLURAY_DEPENDENCIES += freetype
LIBBLURAY_CONF_OPTS += --with-freetype
else
LIBBLURAY_CONF_OPTS += --without-freetype
endif

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
LIBBLURAY_DEPENDENCIES += fontconfig
LIBBLURAY_CONF_OPTS += --with-fontconfig
else
LIBBLURAY_CONF_OPTS += --without-fontconfig
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
LIBBLURAY_DEPENDENCIES += libxml2
LIBBLURAY_CONF_OPTS += --with-libxml2
else
LIBBLURAY_CONF_OPTS += --without-libxml2
endif

$(eval $(autotools-package))
