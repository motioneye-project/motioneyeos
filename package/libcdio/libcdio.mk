################################################################################
#
# libcdio
#
################################################################################

LIBCDIO_VERSION = 0.90
LIBCDIO_SITE = $(BR2_GNU_MIRROR)/libcdio
LIBCDIO_INSTALL_STAGING = YES
LIBCDIO_LICENSE = GPLv3+
LIBCDIO_LICENSE_FILES = COPYING
LIBCDIO_CONF_OPT = --disable-example-progs

ifeq ($(BR2_ENABLE_LOCALE),)
LIBCDIO_DEPENDENCIES += libiconv
endif

$(eval $(autotools-package))
