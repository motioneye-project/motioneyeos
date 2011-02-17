#############################################################
#
# libxcb
#
#############################################################
LIBXCB_VERSION = 1.5
LIBXCB_SOURCE = libxcb-$(LIBXCB_VERSION).tar.bz2
LIBXCB_SITE = http://xcb.freedesktop.org/dist/

LIBXCB_INSTALL_STAGING = YES

LIBXCB_AUTORECONF = NO
LIBXCB_DEPENDENCIES = \
	host-libxslt pthread-stubs xcb-proto xlib_libXdmcp xlib_libXau \
	host-xcb-proto host-python
LIBXCB_CONF_ENV = STAGING_DIR="$(STAGING_DIR)"
LIBXCB_MAKE_OPT = XCBPROTO_XCBINCLUDEDIR=$(STAGING_DIR)/usr/share/xcb \
	XCBPROTO_XCBPYTHONDIR=$(HOST_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages

HOST_LIBXCB_DEPENDENCIES = \
	host-libxslt host-pthread-stubs host-xcb-proto host-xlib_libXdmcp \
	host-xlib_libXau host-python

$(eval $(call AUTOTARGETS,package/x11r7,libxcb))
$(eval $(call AUTOTARGETS,package/x11r7,libxcb,host))

