################################################################################
#
# libfreefare
#
################################################################################

LIBFREEFARE_VERSION = 0.3.4
LIBFREEFARE_SITE = http://libfreefare.googlecode.com/files
LIBFREEFARE_DEPENDENCIES = libnfc openssl
LIBFREEFARE_LICENSE = LGPLv3+ with exception
LIBFREEFARE_LICENSE_FILES = COPYING

ifeq ($(BR2_PREFER_STATIC_LIB),y)
# openssl needs zlib even if the libfreefare example itself doesn't
LIBFREEFARE_CONF_ENV += LIBS='-lz'
endif

$(eval $(autotools-package))
