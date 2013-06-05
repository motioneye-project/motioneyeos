################################################################################
#
# xlib_libXdmcp
#
################################################################################

XLIB_LIBXDMCP_VERSION = 1.1.1
XLIB_LIBXDMCP_SOURCE = libXdmcp-$(XLIB_LIBXDMCP_VERSION).tar.bz2
XLIB_LIBXDMCP_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXDMCP_LICENSE = MIT
XLIB_LIBXDMCP_LICENSE_FILES = COPYING
XLIB_LIBXDMCP_INSTALL_STAGING = YES
XLIB_LIBXDMCP_DEPENDENCIES = xutil_util-macros xproto_xproto

$(eval $(autotools-package))
$(eval $(host-autotools-package))
