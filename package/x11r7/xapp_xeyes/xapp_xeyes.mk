################################################################################
#
# xapp_xeyes -- X.Org xeyes application
#
################################################################################

XAPP_XEYES_VERSION = 1.0.1
XAPP_XEYES_SOURCE = xeyes-$(XAPP_XEYES_VERSION).tar.bz2
XAPP_XEYES_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XEYES_AUTORECONF = YES
XAPP_XEYES_DEPENDANCIES = xlib_libX11 xlib_libXext xlib_libXmu xlib_libXt

$(eval $(call AUTOTARGETS,xapp_xeyes))
