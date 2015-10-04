################################################################################
#
# libembryo
#
################################################################################

LIBEMBRYO_VERSION = $(EFL_VERSION)
LIBEMBRYO_SOURCE = embryo-$(LIBEMBRYO_VERSION).tar.bz2
LIBEMBRYO_SITE = http://download.enlightenment.org/releases
LIBEMBRYO_LICENSE = BSD-2c, Embryo license
LIBEMBRYO_LICENSE_FILES = COPYING

LIBEMBRYO_INSTALL_STAGING = YES

LIBEMBRYO_DEPENDENCIES = host-pkgconf libeina

$(eval $(autotools-package))
$(eval $(host-autotools-package))
