################################################################################
#
# libcdio-paranoia
#
################################################################################

LIBCDIO_PARANOIA_VERSION = 10.2+2.0.1
LIBCDIO_PARANOIA_SOURCE = libcdio-paranoia-$(LIBCDIO_PARANOIA_VERSION).tar.bz2
LIBCDIO_PARANOIA_SITE = $(BR2_GNU_MIRROR)/libcdio
LIBCDIO_PARANOIA_LICENSE = GPL-3.0+
LIBCDIO_PARANOIA_LICENSE_FILES = COPYING
LIBCDIO_PARANOIA_INSTALL_STAGING = YES
LIBCDIO_PARANOIA_DEPENDENCIES = host-pkgconf libcdio
LIBCDIO_PARANOIA_CONF_OPTS = --disable-example-progs

ifeq ($(BR2_INSTALL_LIBSTDCPP),)
LIBCDIO_PARANOIA_CONF_OPTS += --disable-cxx
endif

$(eval $(autotools-package))
