################################################################################
#
# xapp_xdpyinfo -- display information utility for X
#
################################################################################

XAPP_XDPYINFO_VERSION = 1.0.1
XAPP_XDPYINFO_SOURCE = xdpyinfo-$(XAPP_XDPYINFO_VERSION).tar.bz2
XAPP_XDPYINFO_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XDPYINFO_AUTORECONF = YES
XAPP_XDPYINFO_DEPENDANCIES = xlib_libX11 xlib_libXext xlib_libXi xlib_libXp xlib_libXrender xlib_libXtst xlib_libXxf86dga xlib_libXxf86misc xlib_libXxf86vm xproto_inputproto xproto_kbproto xproto_printproto xproto_renderproto xproto_xf86dgaproto xproto_xf86miscproto xproto_xf86vidmodeproto

$(eval $(call AUTOTARGETS,xapp_xdpyinfo))
