################################################################################
#
# libeio
#
################################################################################

LIBEIO_VERSION = $(EFL_VERSION)
LIBEIO_SOURCE = eio-$(LIBEIO_VERSION).tar.bz2
LIBEIO_SITE = http://download.enlightenment.org/releases
LIBEIO_LICENSE = LGPLv2.1
LIBEIO_LICENSE_FILES = COPYING

LIBEIO_INSTALL_STAGING = YES
LIBEIO_DEPENDENCIES = libeina libeet libecore

$(eval $(autotools-package))
