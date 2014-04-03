################################################################################
#
# libcdio
#
################################################################################

LIBCDIO_VERSION = 0.92
LIBCDIO_SITE = $(BR2_GNU_MIRROR)/libcdio
LIBCDIO_INSTALL_STAGING = YES
LIBCDIO_LICENSE = GPLv3+
LIBCDIO_LICENSE_FILES = COPYING
LIBCDIO_CONF_OPT = --disable-example-progs --disable-cddb

ifeq ($(BR2_ENABLE_LOCALE),)
LIBCDIO_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_INSTALL_LIBSTDCPP),)
LIBCDIO_CONF_OPT += --disable-cxx
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
LIBCDIO_DEPENDENCIES += ncurses
else
LIBCDIO_CONF_OPT += --without-cdda-player
endif

$(eval $(autotools-package))
