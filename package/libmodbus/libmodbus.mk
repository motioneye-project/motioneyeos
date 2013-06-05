################################################################################
#
# libmodbus
#
################################################################################

LIBMODBUS_VERSION = 3.0.3
LIBMODBUS_SITE = http://github.com/downloads/stephane/libmodbus
LIBMODBUS_INSTALL_STAGING = YES

$(eval $(autotools-package))
