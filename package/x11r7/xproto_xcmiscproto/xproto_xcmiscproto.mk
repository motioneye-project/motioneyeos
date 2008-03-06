################################################################################
#
# xproto_xcmiscproto -- X.Org XCMisc protocol headers
#
################################################################################

XPROTO_XCMISCPROTO_VERSION = 1.1.2
XPROTO_XCMISCPROTO_SOURCE = xcmiscproto-$(XPROTO_XCMISCPROTO_VERSION).tar.bz2
XPROTO_XCMISCPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XCMISCPROTO_AUTORECONF = NO
XPROTO_XCMISCPROTO_INSTALL_STAGING = YES
XPROTO_XCMISCPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,package/x11r7,xproto_xcmiscproto))
