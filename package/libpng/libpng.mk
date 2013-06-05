################################################################################
#
# libpng
#
################################################################################

LIBPNG_VERSION = 1.4.12
LIBPNG_SERIES = 14
LIBPNG_SOURCE = libpng-$(LIBPNG_VERSION).tar.bz2
LIBPNG_SITE = http://downloads.sourceforge.net/project/libpng/libpng${LIBPNG_SERIES}/$(LIBPNG_VERSION)
LIBPNG_LICENSE = libpng license
LIBPNG_LICENSE_FILES = LICENSE
LIBPNG_INSTALL_STAGING = YES
LIBPNG_DEPENDENCIES = host-pkgconf zlib
LIBPNG_CONFIG_SCRIPTS = libpng$(LIBPNG_SERIES)-config libpng-config

$(eval $(autotools-package))
$(eval $(host-autotools-package))
