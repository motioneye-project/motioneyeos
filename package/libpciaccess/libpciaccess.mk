################################################################################
#
# libpciaccess
#
################################################################################

LIBPCIACCESS_VERSION = 0.13.5
LIBPCIACCESS_SOURCE = libpciaccess-$(LIBPCIACCESS_VERSION).tar.bz2
LIBPCIACCESS_SITE = http://xorg.freedesktop.org/releases/individual/lib
LIBPCIACCESS_LICENSE = MIT
LIBPCIACCESS_LICENSE_FILES = COPYING
LIBPCIACCESS_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBPCIACCESS_CONF_OPTS += --with-zlib
LIBPCIACCESS_DEPENDENCIES += zlib
else
LIBPCIACCESS_CONF_OPTS += --without-zlib
endif

$(eval $(autotools-package))
