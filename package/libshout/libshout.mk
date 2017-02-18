################################################################################
#
# libshout
#
################################################################################

LIBSHOUT_VERSION = 2.4.1
LIBSHOUT_SITE = http://downloads.xiph.org/releases/libshout
LIBSHOUT_LICENSE = LGPLv2+
LIBSHOUT_LICENSE_FILES = COPYING
LIBSHOUT_INSTALL_STAGING = YES
LIBSHOUT_DEPENDENCIES = host-pkgconf libogg libvorbis

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

$(eval $(autotools-package))
