################################################################################
#
# xcb-util-image
#
################################################################################

XCB_UTIL_IMAGE_VERSION = 0.4.0
XCB_UTIL_IMAGE_SITE = http://xcb.freedesktop.org/dist
XCB_UTIL_IMAGE_SOURCE = xcb-util-image-$(XCB_UTIL_IMAGE_VERSION).tar.bz2
XCB_UTIL_IMAGE_INSTALL_STAGING = YES
XCB_UTIL_IMAGE_LICENSE = MIT
XCB_UTIL_IMAGE_DEPENDENCIES = xcb-util

$(eval $(autotools-package))
