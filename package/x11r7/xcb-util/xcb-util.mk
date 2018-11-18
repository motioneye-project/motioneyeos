################################################################################
#
# xcb-util
#
################################################################################

XCB_UTIL_VERSION = 0.4.0
XCB_UTIL_SOURCE = xcb-util-$(XCB_UTIL_VERSION).tar.bz2
XCB_UTIL_SITE = http://xcb.freedesktop.org/dist
XCB_UTIL_LICENSE = MIT
XCB_UTIL_LICENSE_FILES = COPYING
XCB_UTIL_INSTALL_STAGING = YES
XCB_UTIL_DEPENDENCIES = libxcb

$(eval $(autotools-package))
