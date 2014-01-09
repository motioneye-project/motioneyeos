################################################################################
#
# libfreefare
#
################################################################################

LIBFREEFARE_VERSION = 0.3.4
LIBFREEFARE_SITE = http://libfreefare.googlecode.com/files
LIBFREEFARE_DEPENDENCIES = libnfc openssl

ifeq ($(BR2_PREFER_STATIC_LIB),y)
# openssl needs zlib even if the libfreefare example itself doesn't
LIBFREEFARE_CONF_ENV += LIBS='-lz'
endif

$(eval $(autotools-package))
