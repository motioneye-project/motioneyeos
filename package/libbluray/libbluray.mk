################################################################################
#
# libbluray
#
################################################################################

LIBBLURAY_VERSION = 0.6.2
LIBBLURAY_SITE = http://get.videolan.org/libbluray/$(LIBBLURAY_VERSION)
LIBBLURAY_SOURCE = libbluray-$(LIBBLURAY_VERSION).tar.bz2
LIBBLURAY_INSTALL_STAGING = YES
LIBBLURAY_LICENSE = LGPLv2.1+
LIBBLURAY_LICENSE_FILES = COPYING
LIBBLURAY_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_LIBICONV),y)
LIBBLURAY_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
LIBBLURAY_DEPENDENCIES += freetype
else
LIBBLURAY_CONF_OPTS += --without-freetype
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
LIBBLURAY_DEPENDENCIES += libxml2
else
LIBBLURAY_CONF_OPTS += --without-libxml2
endif

$(eval $(autotools-package))
