################################################################################
#
# xlib_libXxf86vm
#
################################################################################

XLIB_LIBXXF86VM_VERSION = 1.1.3
XLIB_LIBXXF86VM_SOURCE = libXxf86vm-$(XLIB_LIBXXF86VM_VERSION).tar.bz2
XLIB_LIBXXF86VM_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXXF86VM_LICENSE = MIT
XLIB_LIBXXF86VM_LICENSE_FILES = COPYING
XLIB_LIBXXF86VM_INSTALL_STAGING = YES
XLIB_LIBXXF86VM_DEPENDENCIES = xlib_libX11 xlib_libXext xproto_xf86vidmodeproto xproto_xproto
XLIB_LIBXXF86VM_CONF_OPTS = --disable-malloc0returnsnull

$(eval $(autotools-package))
