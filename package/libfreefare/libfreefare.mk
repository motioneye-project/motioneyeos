################################################################################
#
# libfreefare
#
################################################################################

LIBFREEFARE_VERSION = 0.3.4
LIBFREEFARE_SITE = http://libfreefare.googlecode.com/files
LIBFREEFARE_DEPENDENCIES = libnfc openssl

$(eval $(autotools-package))
