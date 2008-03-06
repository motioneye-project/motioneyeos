################################################################################
#
# xapp_xtrap -- X.Org xtrap application
#
################################################################################

XAPP_XTRAP_VERSION = 1.0.2
XAPP_XTRAP_SOURCE = xtrap-$(XAPP_XTRAP_VERSION).tar.bz2
XAPP_XTRAP_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XTRAP_AUTORECONF = NO
XAPP_XTRAP_DEPENDENCIES = xlib_libX11 xlib_libXTrap

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xtrap))
