################################################################################
#
# xlib_libXdmcp -- X.Org Xdmcp library
#
################################################################################

XLIB_LIBXDMCP_VERSION = 1.1.0
XLIB_LIBXDMCP_SOURCE = libXdmcp-$(XLIB_LIBXDMCP_VERSION).tar.bz2
XLIB_LIBXDMCP_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXDMCP_INSTALL_STAGING = YES
XLIB_LIBXDMCP_DEPENDENCIES = xutil_util-macros xproto_xproto
XLIB_LIBXDMCP_CONF_OPT = $(if $(BR2_HAVE_DOCUMENTATION),,--disable-docs)
HOST_XLIB_LIBXDMCP_CONF_OPT = --disable-docs

$(eval $(autotools-package))
$(eval $(host-autotools-package))
