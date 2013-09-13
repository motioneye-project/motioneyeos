################################################################################
#
# libxcb
#
################################################################################

LIBXCB_VERSION = 1.8.1
LIBXCB_SOURCE = libxcb-$(LIBXCB_VERSION).tar.bz2
LIBXCB_SITE = http://xcb.freedesktop.org/dist/
LIBXCB_LICENSE = MIT
LIBXCB_LICENSE_FILES = COPYING

LIBXCB_INSTALL_STAGING = YES

LIBXCB_DEPENDENCIES = \
	host-libxslt xlib_libpthread-stubs xcb-proto xlib_libXdmcp xlib_libXau \
	host-xcb-proto host-python host-pkgconf
LIBXCB_CONF_ENV = STAGING_DIR="$(STAGING_DIR)"
LIBXCB_MAKE_OPT = XCBPROTO_XCBINCLUDEDIR=$(STAGING_DIR)/usr/share/xcb \
	XCBPROTO_XCBPYTHONDIR=$(HOST_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages
LIBXCB_CONF_OPT = --disable-build-docs

HOST_LIBXCB_CONF_OPT = --disable-build-docs

$(eval $(autotools-package))
$(eval $(host-autotools-package))
