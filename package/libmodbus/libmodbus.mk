################################################################################
#
# libmodbus
#
################################################################################

LIBMODBUS_VERSION = 3.0.5
LIBMODBUS_SITE = http://libmodbus.org/site_media/build
LIBMODBUS_LICENSE = LGPLv2.1+
LIBMODBUS_LICENSE_FILES = COPYING.LESSER
LIBMODBUS_INSTALL_STAGING = YES

$(eval $(autotools-package))
