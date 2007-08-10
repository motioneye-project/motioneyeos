################################################################################
#
# xapp_xdm -- X.Org xdm application
#
################################################################################

XAPP_XDM_VERSION = 1.1.3
XAPP_XDM_SOURCE = xdm-$(XAPP_XDM_VERSION).tar.bz2
XAPP_XDM_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XDM_AUTORECONF = YES
XAPP_XDM_DEPENDANCIES = xapp_xinit xapp_sessreg xapp_xrdb xlib_libX11 xlib_libXaw xlib_libXdmcp xlib_libXinerama xlib_libXt xproto_xineramaproto xproto_xproto

$(eval $(call AUTOTARGETS,xapp_xdm))
