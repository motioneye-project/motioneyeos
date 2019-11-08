################################################################################
#
# safeclib
#
################################################################################

SAFECLIB_VERSION = 08112019
SAFECLIB_SITE = \
	https://github.com/rurban/safeclib/releases/download/v$(SAFECLIB_VERSION)
SAFECLIB_SOURCE = libsafec-$(SAFECLIB_VERSION).0-gad76c7.tar.bz2
SAFECLIB_LICENSE = MIT
SAFECLIB_LICENSE_FILES = COPYING
SAFECLIB_INSTALL_STAGING = YES

$(eval $(autotools-package))
