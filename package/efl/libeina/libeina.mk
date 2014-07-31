################################################################################
#
# libeina
#
################################################################################

LIBEINA_VERSION = $(EFL_VERSION)
LIBEINA_SOURCE = eina-$(LIBEINA_VERSION).tar.bz2
LIBEINA_SITE = http://download.enlightenment.org/releases
LIBEINA_LICENSE = LGPLv2.1+
LIBEINA_LICENSE_FILES = COPYING

LIBEINA_INSTALL_STAGING = YES

LIBEINA_DEPENDENCIES = host-pkgconf

$(eval $(autotools-package))
$(eval $(host-autotools-package))
