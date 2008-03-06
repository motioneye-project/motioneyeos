#############################################################
#
# xcb-proto
#
#############################################################
XCB_PROTO_VERSION = 1.1
XCB_PROTO_SOURCE = xcb-proto-$(XCB_PROTO_VERSION).tar.bz2
XCB_PROTO_SITE = http://xcb.freedesktop.org/dist/

XCB_PROTO_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package/x11r7,xcb-proto))

