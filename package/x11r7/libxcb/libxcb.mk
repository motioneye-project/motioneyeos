#############################################################
#
# libxcb
#
#############################################################
LIBXCB_VERSION = 1.0
LIBXCB_SOURCE = libxcb-$(LIBXCB_VERSION).tar.bz2
LIBXCB_SITE = http://xcb.freedesktop.org/dist/

LIBXCB_INSTALL_STAGING = YES

LIBXCB_AUTORECONF = YES
LIBXCB_DEPENDENCIES = pthread-stubs xcb-proto xlib_libXdmcp xlib_libXau
LIBXCB_CONF_ENV = STAGING_DIR="$(STAGING_DIR)"

$(eval $(call AUTOTARGETS,package/x11r7,libxcb))

