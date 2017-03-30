################################################################################
#
# libphidget
#
################################################################################

LIBPHIDGET_VERSION = 2.1.8.20140319
LIBPHIDGET_SOURCE = libphidget_$(LIBPHIDGET_VERSION).tar.gz
LIBPHIDGET_SITE = http://www.phidgets.com/downloads/libraries
LIBPHIDGET_DEPENDENCIES = libusb
LIBPHIDGET_CONF_OPTS = --disable-ldconfig
LIBPHIDGET_INSTALL_STAGING = YES
LIBPHIDGET_LICENSE = LGPL-3.0
LIBPHIDGET_LICENSE_FILES = COPYING

$(eval $(autotools-package))
