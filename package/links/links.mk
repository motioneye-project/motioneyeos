################################################################################
#
# links
#
################################################################################

LINKS_VERSION = 2.7
LINKS_SITE = http://links.twibright.com/download
LINKS_DEPENDENCIES = host-pkgconf
LINKS_LICENSE = GPLv2+
LINKS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LINKS_GRAPHICS),y)
LINKS_CONF_OPT += --enable-graphics
LINKS_DEPENDENCIES += libpng
ifeq ($(BR2_PACKAGE_XLIB_LIBXT),y)
LINKS_CONF_OPT += --with-x
LINKS_DEPENDENCIES += xlib_libXt
else
LINKS_CONF_OPT += --without-x
endif
ifeq ($(BR2_PACKAGE_DIRECTFB),y)
LINKS_CONF_ENV = ac_cv_path_DIRECTFB_CONFIG=$(STAGING_DIR)/usr/bin/directfb-config
LINKS_CONF_OPT += --with-directfb
LINKS_DEPENDENCIES += directfb
else
LINKS_CONF_OPT += --without-directfb
endif
ifeq ($(BR2_PACKAGE_JPEG),y)
LINKS_DEPENDENCIES += jpeg
endif
ifeq ($(BR2_PACKAGE_TIFF),y)
LINKS_DEPENDENCIES += tiff
endif
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
LINKS_DEPENDENCIES += bzip2
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LINKS_DEPENDENCIES += openssl
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LINKS_DEPENDENCIES += zlib
endif

$(eval $(autotools-package))
