################################################################################
#
# xcb-util
#
################################################################################

XCB_UTIL_VERSION = 0.3.9
XCB_UTIL_SOURCE = xcb-util-$(XCB_UTIL_VERSION).tar.bz2
XCB_UTIL_SITE = http://xcb.freedesktop.org/dist/

# unfortunately, no license file
XCB_UTIL_LICENSE = MIT

XCB_UTIL_INSTALL_STAGING = YES
XCB_UTIL_DEPENDENCIES = host-gperf libxcb

$(eval $(autotools-package))

