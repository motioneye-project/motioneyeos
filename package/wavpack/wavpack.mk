################################################################################
#
# wavpack
#
################################################################################

WAVPACK_VERSION = 4.60.1
WAVPACK_SITE = http://www.wavpack.com
WAVPACK_SOURCE = wavpack-$(WAVPACK_VERSION).tar.bz2
WAVPACK_INSTALL_STAGING = YES
# configure not up to date
WAVPACK_AUTORECONF = YES
WAVPACK_DEPENDENCIES = $(if $(BR2_ENABLE_LOCALE),,libiconv)
WAVPACK_LICENSE = BSD-3c
WAVPACK_LICENSE_FILES = license.txt

$(eval $(autotools-package))
