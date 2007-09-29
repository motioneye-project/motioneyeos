#############################################################
#
# xcb-util
#
#############################################################
XCB_UTIL_VERSION = 0.2
XCB_UTIL_SOURCE = xcb-util-$(XCB_UTIL_VERSION).tar.bz2
XCB_UTIL_SITE = http://xcb.freedesktop.org/dist/

$(eval $(call AUTOTARGETS,package/x11r7,xcb-util))

