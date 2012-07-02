################################################################################
#
# xapp_rstart -- X.Org rstart application
#
################################################################################

XAPP_RSTART_VERSION = 1.0.2
XAPP_RSTART_SOURCE = rstart-$(XAPP_RSTART_VERSION).tar.bz2
XAPP_RSTART_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_RSTART_DEPENDENCIES = xlib_libX11

$(eval $(autotools-package))
