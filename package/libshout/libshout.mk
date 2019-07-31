################################################################################
#
# libshout
#
################################################################################

LIBSHOUT_VERSION = 2.4.3
LIBSHOUT_SITE = https://downloads.xiph.org/releases/libshout
LIBSHOUT_LICENSE = LGPL-2.0+
LIBSHOUT_LICENSE_FILES = COPYING
LIBSHOUT_INSTALL_STAGING = YES
LIBSHOUT_DEPENDENCIES = host-pkgconf libogg libvorbis
LIBSHOUT_CONF_OPTS = --disable-examples

ifeq ($(BR2_PACKAGE_LIBTHEORA),y)
LIBSHOUT_CONF_OPTS += --enable-theora
LIBSHOUT_DEPENDENCIES += libtheora
else
LIBSHOUT_CONF_OPTS += --disable-theora
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
LIBSHOUT_CONF_OPTS += --enable-speex
LIBSHOUT_DEPENDENCIES += speex
else
LIBSHOUT_CONF_OPTS += --disable-speex
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBSHOUT_CONF_OPTS += --with-openssl
LIBSHOUT_DEPENDENCIES += openssl
else ifeq ($(BR2_PACKAGE_LIBRESSL),y)
LIBSHOUT_CONF_OPTS += --with-openssl=$(STAGING_DIR)/lib
LIBSHOUT_DEPENDENCIES += libressl
else
LIBSHOUT_CONF_OPTS += --without-openssl
endif

$(eval $(autotools-package))
