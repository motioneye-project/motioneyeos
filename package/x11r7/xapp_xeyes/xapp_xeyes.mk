################################################################################
#
# xapp_xeyes -- X.Org xeyes application
#
################################################################################

XAPP_XEYES_VERSION = 1.0.1
XAPP_XEYES_SOURCE = xeyes-$(XAPP_XEYES_VERSION).tar.bz2
XAPP_XEYES_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XEYES_AUTORECONF = NO
XAPP_XEYES_DEPENDENCIES = xlib_libX11 xlib_libXext xlib_libXmu xlib_libXt

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xeyes))
