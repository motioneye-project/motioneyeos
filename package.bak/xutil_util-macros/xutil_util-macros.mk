################################################################################
#
# xutil_util-macros
#
################################################################################

XUTIL_UTIL_MACROS_VERSION = 1.19.1
XUTIL_UTIL_MACROS_SOURCE = util-macros-$(XUTIL_UTIL_MACROS_VERSION).tar.bz2
XUTIL_UTIL_MACROS_SITE = http://xorg.freedesktop.org/releases/individual/util
XUTIL_UTIL_MACROS_LICENSE = MIT
XUTIL_UTIL_MACROS_LICENSE_FILES = COPYING

XUTIL_UTIL_MACROS_INSTALL_STAGING = YES
XUTIL_UTIL_MACROS_INSTALL_TARGET = NO

$(eval $(autotools-package))
$(eval $(host-autotools-package))
