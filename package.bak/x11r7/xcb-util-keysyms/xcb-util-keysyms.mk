################################################################################
#
# xcb-util-keysyms
#
################################################################################

XCB_UTIL_KEYSYMS_VERSION = 0.4.0
XCB_UTIL_KEYSYMS_SOURCE = xcb-util-keysyms-$(XCB_UTIL_KEYSYMS_VERSION).tar.bz2
XCB_UTIL_KEYSYMS_SITE = http://xcb.freedesktop.org/dist

# unfortunately, no license file
XCB_UTIL_KEYSYMS_LICENSE = MIT

XCB_UTIL_KEYSYMS_INSTALL_STAGING = YES

XCB_UTIL_KEYSYMS_DEPENDENCIES = host-pkgconf libxcb

$(eval $(autotools-package))
