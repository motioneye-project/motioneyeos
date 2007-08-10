################################################################################
#
# xapp_xclipboard -- interchange between cut buffer and selection
#
################################################################################

XAPP_XCLIPBOARD_VERSION = 1.0.1
XAPP_XCLIPBOARD_SOURCE = xclipboard-$(XAPP_XCLIPBOARD_VERSION).tar.bz2
XAPP_XCLIPBOARD_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XCLIPBOARD_AUTORECONF = YES
XAPP_XCLIPBOARD_DEPENDANCIES = xlib_libXaw

$(eval $(call AUTOTARGETS,xapp_xclipboard))
