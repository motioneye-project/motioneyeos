################################################################################
#
# xapp_mkfontdir -- create an index of X font files in a directory
#
################################################################################

XAPP_MKFONTDIR_VERSION = 1.0.5
XAPP_MKFONTDIR_SOURCE = mkfontdir-$(XAPP_MKFONTDIR_VERSION).tar.bz2
XAPP_MKFONTDIR_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_MKFONTDIR_DEPENDENCIES = xapp_mkfontscale

$(eval $(autotools-package))
$(eval $(host-autotools-package))
