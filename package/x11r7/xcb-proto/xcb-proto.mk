#############################################################
#
# xcb-proto
#
#############################################################
XCB_PROTO_VERSION = 1.6
XCB_PROTO_SOURCE = xcb-proto-$(XCB_PROTO_VERSION).tar.bz2
XCB_PROTO_SITE = http://xcb.freedesktop.org/dist/

XCB_PROTO_INSTALL_STAGING = YES

XCB_PROTO_DEPENDENCIES = host-python

$(eval $(autotools-package))
$(eval $(host-autotools-package))

