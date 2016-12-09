################################################################################
#
# links
#
################################################################################

LINKS_VERSION = 2.14
LINKS_SOURCE = links-$(LINKS_VERSION).tar.bz2
LINKS_SITE = http://links.twibright.com/download
LINKS_DEPENDENCIES = host-pkgconf
LINKS_LICENSE = GPLv2+
LINKS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LINKS_GRAPHICS),y)
LINKS_CONF_OPTS += --enable-graphics
LINKS_DEPENDENCIES += libpng
ifeq ($(BR2_PACKAGE_XLIB_LIBXT),y)
LINKS_CONF_OPTS += --with-x
LINKS_DEPENDENCIES += xlib_libXt
else
LINKS_CONF_OPTS += --without-x
endif
ifeq ($(BR2_PACKAGE_DIRECTFB),y)
LINKS_CONF_ENV = ac_cv_path_DIRECTFB_CONFIG=$(STAGING_DIR)/usr/bin/directfb-config
ifeq ($(BR2_STATIC_LIBS),y)
LINKS_CONF_ENV += LIBS=-lstdc++
endif
LINKS_CONF_OPTS += --with-directfb
LINKS_DEPENDENCIES += directfb
else
LINKS_CONF_OPTS += --without-directfb
endif
ifeq ($(BR2_PACKAGE_JPEG),y)
LINKS_CONF_OPTS += --with-libjpeg
LINKS_DEPENDENCIES += jpeg
else
LINKS_CONF_OPTS += --without-libjpeg
endif
ifeq ($(BR2_PACKAGE_LIBRSVG),y)
LINKS_CONF_OPTS += --with-librsvg
LINKS_DEPENDENCIES += librsvg
else
LINKS_CONF_OPTS += --without-librsvg
endif
ifeq ($(BR2_PACKAGE_TIFF),y)
LINKS_CONF_OPTS += --with-libtiff
LINKS_DEPENDENCIES += tiff
else
LINKS_CONF_OPTS += --without-libtiff
endif
else
LINKS_CONF_OPTS += --disable-graphics
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
LINKS_CONF_OPTS += --with-bzip2
LINKS_DEPENDENCIES += bzip2
else
LINKS_CONF_OPTS += --without-bzip2
endif

ifeq ($(BR2_PACKAGE_GPM),y)
LINKS_CONF_OPTS += --with-gpm
LINKS_DEPENDENCIES += gpm
else
LINKS_CONF_OPTS += --without-gpm
endif

ifeq ($(BR2_PACKAGE_LIBEVENT),y)
LINKS_CONF_OPTS += --with-libevent
LINKS_DEPENDENCIES += libevent
else
LINKS_CONF_OPTS += --without-libevent
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LINKS_CONF_OPTS += --with-ssl --enable-ssl-pkgconfig
LINKS_DEPENDENCIES += openssl
else
LINKS_CONF_OPTS += --without-ssl
endif

ifeq ($(BR2_PACKAGE_XZ),y)
LINKS_CONF_OPTS += --with-lzma
LINKS_DEPENDENCIES += xz
else
LINKS_CONF_OPTS += --without-lzma
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LINKS_CONF_OPTS += --with-zlib
LINKS_DEPENDENCIES += zlib
else
LINKS_CONF_OPTS += --without-zlib
endif

$(eval $(autotools-package))
