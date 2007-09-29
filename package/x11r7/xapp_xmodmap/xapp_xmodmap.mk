################################################################################
#
# xapp_xmodmap -- utility for modifying keymaps and pointer button mappings in X
#
################################################################################

XAPP_XMODMAP_VERSION = 1.0.2
XAPP_XMODMAP_SOURCE = xmodmap-$(XAPP_XMODMAP_VERSION).tar.bz2
XAPP_XMODMAP_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XMODMAP_AUTORECONF = YES
XAPP_XMODMAP_DEPENDENCIES = xlib_libX11

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xmodmap))
