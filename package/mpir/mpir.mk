################################################################################
#
# mpir
#
################################################################################

MPIR_VERSION = 3.0.0
MPIR_SITE = http://www.mpir.org
MPIR_SOURCE = mpir-$(MPIR_VERSION).tar.bz2
MPIR_LICENSE = LGPL-3.0+
MPIR_LICENSE_FILES = COPYING.LIB
MPIR_INSTALL_STAGING = YES
MPIR_DEPENDENCIES = gmp host-yasm

$(eval $(autotools-package))
