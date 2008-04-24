################################################################################
#
# xapp_xclock -- analog / digital clock for X
#
################################################################################

XAPP_XCLOCK_VERSION = 1.0.3
XAPP_XCLOCK_SOURCE = xclock-$(XAPP_XCLOCK_VERSION).tar.bz2
XAPP_XCLOCK_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XCLOCK_AUTORECONF = NO
XAPP_XCLOCK_DEPENDENCIES = xlib_libX11 xlib_libXaw xlib_libXft xlib_libXrender xlib_libxkbfile

XAPP_XCLOCK_CONF_OPT = LDFLAGS="-liconv"

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xclock))
