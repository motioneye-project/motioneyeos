################################################################################
#
# xutil_util-macros -- No description available
#
################################################################################

XUTIL_UTIL_MACROS_VERSION = 1.1.5
XUTIL_UTIL_MACROS_SOURCE = util-macros-$(XUTIL_UTIL_MACROS_VERSION).tar.bz2
XUTIL_UTIL_MACROS_SITE = http://xorg.freedesktop.org/releases/individual/util
XUTIL_UTIL_MACROS_AUTORECONF = YES
XUTIL_UTIL_MACROS_INSTALL_STAGING = YES
XUTIL_UTIL_MACROS_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,xutil_util-macros))
