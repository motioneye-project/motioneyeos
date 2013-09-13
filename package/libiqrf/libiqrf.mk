################################################################################
#
# libiqrf
#
################################################################################

LIBIQRF_VERSION = v0.1.2
LIBIQRF_SITE = http://github.com/nandra/libiqrf/tarball/$(LIBIQRF_VERSION)
LIBIQRF_INSTALL_STAGING = YES

LIBIQRF_DEPENDENCIES = libusb

$(eval $(cmake-package))
