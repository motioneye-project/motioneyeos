################################################################################
#
# xlib_xtrans
#
################################################################################

XLIB_XTRANS_VERSION = 1.2.7
XLIB_XTRANS_SOURCE = xtrans-$(XLIB_XTRANS_VERSION).tar.bz2
XLIB_XTRANS_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_XTRANS_LICENSE = MIT
XLIB_XTRANS_LICENSE_FILES = COPYING
XLIB_XTRANS_INSTALL_STAGING = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
