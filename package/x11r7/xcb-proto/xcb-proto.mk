################################################################################
#
# xcb-proto
#
################################################################################

XCB_PROTO_VERSION = 1.7.1
XCB_PROTO_SOURCE = xcb-proto-$(XCB_PROTO_VERSION).tar.bz2
XCB_PROTO_SITE = http://xcb.freedesktop.org/dist/
XCB_PROTO_LICENSE = MIT
XCB_PROTO_LICENSE_FILES = COPYING

XCB_PROTO_INSTALL_STAGING = YES

XCB_PROTO_DEPENDENCIES = host-python

$(eval $(autotools-package))
$(eval $(host-autotools-package))

