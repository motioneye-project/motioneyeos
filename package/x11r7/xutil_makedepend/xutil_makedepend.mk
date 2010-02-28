################################################################################
#
# xutil_makedepend -- No description available
#
################################################################################

XUTIL_MAKEDEPEND_VERSION = 1.0.2
XUTIL_MAKEDEPEND_SOURCE = makedepend-$(XUTIL_MAKEDEPEND_VERSION).tar.bz2
XUTIL_MAKEDEPEND_SITE = http://xorg.freedesktop.org/releases/individual/util
XUTIL_MAKEDEPEND_AUTORECONF = NO
XUTIL_MAKEDEPEND_INSTALL_STAGING = NO
XUTIL_MAKEDEPEND_INSTALL_TARGET = YES

HOST_XUTIL_MAKEDEPEND_DEPENDENCIES = host-xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xutil_makedepend))
$(eval $(call AUTOTARGETS,package/x11r7,xutil_makedepend,host))
