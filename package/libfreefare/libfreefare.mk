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
LIBFREEFARE_DEPENDENCIES = libnfc openssl
LIBFREEFARE_LICENSE = LGPLv3+ with exception
LIBFREEFARE_LICENSE_FILES = COPYING

ifeq ($(BR2_STATIC_LIBS),y)
# openssl needs zlib even if the libfreefare example itself doesn't
LIBFREEFARE_CONF_ENV += LIBS='-lz'
endif

$(eval $(autotools-package))
