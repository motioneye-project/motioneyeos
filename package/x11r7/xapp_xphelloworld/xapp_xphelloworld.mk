################################################################################
#
# xapp_xphelloworld -- X.Org xphelloworld application
#
################################################################################

XAPP_XPHELLOWORLD_VERSION = 1.0.1
XAPP_XPHELLOWORLD_SOURCE = xphelloworld-$(XAPP_XPHELLOWORLD_VERSION).tar.bz2
XAPP_XPHELLOWORLD_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XPHELLOWORLD_AUTORECONF = YES
XAPP_XPHELLOWORLD_DEPENDANCIES = xlib_libXaw xlib_libXprintAppUtil xlib_libXprintUtil xlib_libXt

$(eval $(call AUTOTARGETS,xapp_xphelloworld))
