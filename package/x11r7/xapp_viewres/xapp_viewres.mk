################################################################################
#
# xapp_viewres -- graphical class browser for Xt
#
################################################################################

XAPP_VIEWRES_VERSION = 1.0.1
XAPP_VIEWRES_SOURCE = viewres-$(XAPP_VIEWRES_VERSION).tar.bz2
XAPP_VIEWRES_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_VIEWRES_DEPENDENCIES = xlib_libXaw

$(eval $(autotools-package))
