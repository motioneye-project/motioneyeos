#############################################################
#
# xcb-util-keysyms
#
#############################################################
XCB_UTIL_KEYSYMS_VERSION = 0.3.9
XCB_UTIL_KEYSYMS_SOURCE = xcb-util-keysyms-$(XCB_UTIL_KEYSYMS_VERSION).tar.bz2
XCB_UTIL_KEYSYMS_SITE = http://xcb.freedesktop.org/dist/
XCB_UTIL_KEYSYMS_INSTALL_STAGING = YES

$(eval $(autotools-package))

