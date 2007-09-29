################################################################################
#
# xutil_makedepend -- No description available
#
################################################################################

XUTIL_MAKEDEPEND_VERSION = 1.0.0
XUTIL_MAKEDEPEND_SOURCE = makedepend-$(XUTIL_MAKEDEPEND_VERSION).tar.bz2
XUTIL_MAKEDEPEND_SITE = http://xorg.freedesktop.org/releases/individual/util
XUTIL_MAKEDEPEND_AUTORECONF = YES
XUTIL_MAKEDEPEND_INSTALL_STAGING = YES
XUTIL_MAKEDEPEND_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,package/x11r7,xutil_makedepend))
