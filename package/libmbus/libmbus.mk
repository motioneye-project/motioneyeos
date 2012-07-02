#############################################################
#
# libmbus
#
#############################################################

LIBMBUS_VERSION = 0.7.0
LIBMBUS_SITE = http://www.freescada.com/public-dist
LIBMBUS_INSTALL_STAGING = YES

# Without this the build yields an error:
#   cannot find input file: `test/Makefile.in'
LIBMBUS_AUTORECONF = YES

$(eval $(autotools-package))
