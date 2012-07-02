#############################################################
#
# libiqrf library
#
#############################################################

LIBIQRF_VERSION = v0.1.0
LIBIQRF_SITE = git://github.com/nandra/libiqrf.git
LIBIQRF_INSTALL_STAGING = YES

LIBIQRF_DEPENDENCIES = libusb

$(eval $(autotools-package))

