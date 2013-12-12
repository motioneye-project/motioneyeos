################################################################################
#
# wavpack
#
################################################################################

WAVPACK_VERSION = 4.70.0
WAVPACK_SITE = http://www.wavpack.com
WAVPACK_SOURCE = wavpack-$(WAVPACK_VERSION).tar.bz2
WAVPACK_INSTALL_STAGING = YES
# configure not up to date
WAVPACK_AUTORECONF = YES
WAVPACK_DEPENDENCIES = $(if $(BR2_ENABLE_LOCALE),,libiconv)
WAVPACK_LICENSE = BSD-3c
WAVPACK_LICENSE_FILES = COPYING

$(eval $(autotools-package))
