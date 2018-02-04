################################################################################
#
# xcb-util-wm
#
################################################################################

XCB_UTIL_WM_VERSION = 0.4.1
XCB_UTIL_WM_SITE = http://xcb.freedesktop.org/dist
XCB_UTIL_WM_SOURCE = xcb-util-wm-$(XCB_UTIL_WM_VERSION).tar.bz2
XCB_UTIL_WM_INSTALL_STAGING = YES
XCB_UTIL_WM_LICENSE = MIT
XCB_UTIL_WM_LICENSE_FILES = COPYING
XCB_UTIL_WM_DEPENDENCIES = libxcb

$(eval $(autotools-package))
