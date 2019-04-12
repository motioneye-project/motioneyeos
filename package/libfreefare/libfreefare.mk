################################################################################
#
# libfreefare
#
################################################################################

LIBFREEFARE_VERSION = 0.4.0
LIBFREEFARE_SOURCE = libfreefare-$(LIBFREEFARE_VERSION).tar.bz2
# Do not use the github helper here, the generated tarball is *NOT*
# the same as the one uploaded by upstream for the release.
LIBFREEFARE_SITE = https://github.com/nfc-tools/libfreefare/releases/download/libfreefare-$(LIBFREEFARE_VERSION)
LIBFREEFARE_DEPENDENCIES = host-pkgconf libnfc openssl
LIBFREEFARE_LICENSE = LGPL-3.0+ with exception
LIBFREEFARE_LICENSE_FILES = COPYING
LIBFREEFARE_CONF_ENV += LIBS=`$(PKG_CONFIG_HOST_BINARY) --libs openssl`

$(eval $(autotools-package))
