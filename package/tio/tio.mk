################################################################################
#
# tio
#
################################################################################

TIO_VERSION = 1.32
TIO_SOURCE = tio-$(TIO_VERSION).tar.xz
TIO_SITE = https://github.com/tio/tio/releases/download/v$(TIO_VERSION)
TIO_LICENSE = GPL-2.0+
TIO_LICENSE_FILES = COPYING

$(eval $(autotools-package))
