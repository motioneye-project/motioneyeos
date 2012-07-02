#############################################################
#
# xcb-util
#
#############################################################
XCB_UTIL_VERSION = 0.3.6
XCB_UTIL_SOURCE = xcb-util-$(XCB_UTIL_VERSION).tar.bz2
XCB_UTIL_SITE = http://xcb.freedesktop.org/dist/
XCB_UTIL_INSTALL_STAGING = YES
XCB_UTIL_DEPENDENCIES = host-gperf

$(eval $(autotools-package))

