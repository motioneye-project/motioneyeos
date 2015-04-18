################################################################################
#
# xcb-util-renderutil
#
################################################################################

XCB_UTIL_RENDERUTIL_VERSION = 0.3.9
XCB_UTIL_RENDERUTIL_SITE = http://xcb.freedesktop.org/dist
XCB_UTIL_RENDERUTIL_SOURCE = xcb-util-renderutil-$(XCB_UTIL_RENDERUTIL_VERSION).tar.bz2
XCB_UTIL_RENDERUTIL_LICENSE = MIT
XCB_UTIL_RENDERUTIL_LICENSE_FILES = COPYING
XCB_UTIL_RENDERUTIL_INSTALL_STAGING = YES
XCB_UTIL_RENDERUTIL_DEPENDENCIES = xcb-util

$(eval $(autotools-package))
