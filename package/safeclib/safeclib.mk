################################################################################
#
# safeclib
#
################################################################################

SAFECLIB_VERSION = 17102019
SAFECLIB_SITE = \
	https://github.com/rurban/safeclib/releases/download/v$(SAFECLIB_VERSION)
SAFECLIB_SOURCE = libsafec-$(SAFECLIB_VERSION).0-g5d92be.tar.bz2
SAFECLIB_LICENSE = MIT
SAFECLIB_LICENSE_FILES = COPYING
SAFECLIB_INSTALL_STAGING = YES

$(eval $(autotools-package))
